import cv2
import mediapipe as mp
import numpy as np
from ivy.ivy import IvyServer 

class IvyAgent(IvyServer):
    def __init__(self,name):
        IvyServer.__init__(self,"PyMove")
        self.start('127.255.255.255:2010')

    def send(self,message):
        s = "PyMove msg="+message
        self.send_msg(s)

def detect_shape(contour):
    if contour == []:
        return ""
    contour = np.array(contour, dtype=np.float32)
    contour = contour.reshape((-1, 2)) 
    epsilon = 0.04 * cv2.arcLength(contour,True)
    approx = cv2.approxPolyDP(contour,epsilon,True)

    if len(approx)==3:
        return "Triangle"
    elif len(approx)==4:
        x,y,w,h = cv2.boundingRect(approx)
        aspect_ratio = w / float(h)

        if 0.95 <= aspect_ratio <= 1.05:
            return "Carré"
        else:
            return "Rectangle"
    else:
        (x,y),radius = cv2.minEnclosingCircle(contour)
        area = cv2.contourArea(contour)
        circularity = 4 * np.pi * area / (cv2.arcLength(contour,True)**2)
        if circularity > 0.8:
            return "Cercle"
        else:
            return ""
        
cam = cv2.VideoCapture(0)

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False,max_num_hands=1,
                       min_detection_confidence=0.5, min_tracking_confidence=0.5)

mp_drawing = mp.solutions.drawing_utils

list_draw = []

agent = IvyAgent("PyMove")

while True:
    ret, frame = cam.read()
    if not ret:
        break

    image_height, image_width, _ = frame.shape
    image_rgb = cv2.cvtColor(frame,cv2.COLOR_BGR2RGB)

    results = hands.process(image_rgb)

    if results.multi_hand_landmarks:
        for hand_landmarks in results.multi_hand_landmarks:
            mp_drawing.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

            index_finger_y = hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP].y
            index_finger_x = hand_landmarks.landmark[mp_hands.HandLandmark.INDEX_FINGER_TIP].x
            major_finger_y = hand_landmarks.landmark[mp_hands.HandLandmark.MIDDLE_FINGER_TIP].y
            ring_finger_y = hand_landmarks.landmark[mp_hands.HandLandmark.RING_FINGER_TIP].y
            thumb_y = hand_landmarks.landmark[mp_hands.HandLandmark.THUMB_TIP].y

            if index_finger_y < thumb_y-0.05 and major_finger_y < thumb_y-0.05 and ring_finger_y < thumb_y-0.04: 
                hand_gesture = "send"
            elif index_finger_y < thumb_y-0.08 and major_finger_y < thumb_y-0.08:
                hand_gesture = "erase"
            elif index_finger_y < thumb_y-0.05:
                hand_gesture = "up"
            else:
                hand_gesture = "stop"

            if hand_gesture == "erase":
                list_draw = []
            if hand_gesture == "up":
                list_draw.append((index_finger_x*image_width,index_finger_y*image_height))
            if hand_gesture == "send":
                r = detect_shape(list_draw)
                print(r)
                if r != "":
                    agent.send(r)

            for point in list_draw:
                cv2.circle(frame, (int(point[0]), int(point[1])), 10, (255, 0, 0), -1)
                #frame[int(point[1]),int(point[0])] = (255,0,0)

    cv2.imshow("PyGesture",frame)
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

cam.release()
cv2.destroyAllWindows()
