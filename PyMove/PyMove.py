import cv2
import mediapipe as mp
import numpy as np
from ivy.ivy import IvyServer 
import math

list_forme = []

class IvyAgent(IvyServer):
    def __init__(self,name):
        IvyServer.__init__(self,"PyMove")
        self.start('127.255.255.255:2010')
        self.bind_msg(self.handle_forme,"^Formes Liste=(.*)")

    def send(self,message):
        s = "PyMove msg="+message
        self.send_msg(s)

    def handle_forme(self,agent,arg):
        global list_forme
        l = arg.split("#")
        list_forme = []
        for i in l:
            if i != "":
                f = i.split(",")
                list_forme.append(f)

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
        try:
            (x,y),radius = cv2.minEnclosingCircle(contour)
            area = cv2.contourArea(contour)
            circularity = 4 * np.pi * area / (cv2.arcLength(contour,True)**2)
            if circularity > 0.5:
                return "Cercle"
            else:
                return ""
        except:
            return ""

def dessiner_triangle(image, top_right, color, thickness=2):
    largeur = int(100/1600*image_width)
    hauteur = int(100/1000*image_height)
    point1 = top_right
    point2 = (top_right[0] - largeur // 2, top_right[1] + hauteur)
    point3 = (top_right[0] + largeur // 2, top_right[1] + hauteur)

    cv2.line(image, point1, point2, color, thickness)
    cv2.line(image, point2, point3, color, thickness)
    cv2.line(image, point3, point1, color, thickness)

def dessiner_corbeille(image):
    trash_bin = cv2.imread('./PyMove/supprimer.png')
    if trash_bin is None:
        print("L'image de la corbeille n'a pas été trouvée.")
        return

    image_height, image_width, _ = image.shape
    
    # Redimensionne image clear pour coin supérieur droit
    scale = 0.08  # Facteur d'échelle pour redimensionner l'image
    trash_bin_resized = cv2.resize(trash_bin, (int(image_width * (scale+0.02)), int(image_height * scale)))
    
    # Calculer les coordonnées du coin supérieur gauche pour placer l'image
    top_left_x = image_width - trash_bin_resized.shape[1]
    top_left_y = 0
    
    # Superpose l'image sur le fenetre cam
    image[top_left_y:top_left_y + trash_bin_resized.shape[0], top_left_x:top_left_x + trash_bin_resized.shape[1]] = trash_bin_resized


cam = cv2.VideoCapture(0)

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False,max_num_hands=1,
                       min_detection_confidence=0.7, min_tracking_confidence=0.7)

mp_drawing = mp.solutions.drawing_utils

list_draw = []

agent = IvyAgent("PyMove")

hand_gesture = ""
old_gesture = ""

while cam.isOpened():
    ret, frame = cam.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1) #miroir
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
            thumb_x = hand_landmarks.landmark[mp_hands.HandLandmark.THUMB_TIP].x

            if index_finger_y < thumb_y-0.05 and major_finger_y < thumb_y-0.05 and ring_finger_y < thumb_y-0.04: 
                hand_gesture = "send"
            elif index_finger_y < thumb_y-0.08 and major_finger_y < thumb_y-0.08:
                hand_gesture = "erase"
            elif index_finger_y < thumb_y-0.05:
                hand_gesture = "up"
            elif math.dist((index_finger_x,index_finger_y),(thumb_x,thumb_y)) < 0.1:
                hand_gesture = "take"
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
            if hand_gesture=="take" and old_gesture!="take":
                agent.send("newtake,"+str(index_finger_x*1600)+","+str(index_finger_y*1000))
                print("new_take")
            elif hand_gesture=="take":
                print("take")
                agent.send("take,"+str(index_finger_x*1600)+","+str(index_finger_y*1000))
            elif old_gesture=="take":
                agent.send("release")
                print("release")


            for point in list_draw:
                cv2.circle(frame, (int(point[0]), int(point[1])), 10, (255, 0, 0), -1)
                #frame[int(point[1]),int(point[0])] = (255,0,0)


            old_gesture = hand_gesture

    if hand_gesture != "send" and hand_gesture != "erase" and hand_gesture != "up":
        for forme in list_forme:
            if forme[0]=="Rectangle":
                top = (int(int(forme[4])/1600*image_width),int(int(forme[5])/1000*image_height))
                bottom = (int((int(forme[4])+100)/1600*image_width),int((int(forme[5])+200)/1000*image_height))
                cv2.rectangle(frame,top,bottom,(int(forme[3]),int(forme[2]),int(forme[1])),5)
            if forme[0]=="Carre":
                top = (int(int(forme[4])/1600*image_width),int(int(forme[5])/1000*image_height))
                bottom = (int((int(forme[4])+100)/1600*image_width),int((int(forme[5])+100)/1000*image_height))
                cv2.rectangle(frame,top,bottom,(int(forme[3]),int(forme[2]),int(forme[1])),5)
            elif forme[0]=="Cercle":
                center = (int(int(forme[4])/1600*image_width),int(int(forme[5])/1000*image_height))
                cv2.circle(frame, center, int(100/1600*image_width), (int(forme[3]),int(forme[2]),int(forme[1])),5)
            elif forme[0]=="Triangle":
                center = (int(int(forme[4])/1600*image_width),int(int(forme[5])/1000*image_height))
                dessiner_triangle(frame,center,(int(forme[3]),int(forme[2]),int(forme[1])),5)

    dessiner_corbeille(frame)
    cv2.imshow("PyGesture",frame)
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

cam.release()
cv2.destroyAllWindows()
