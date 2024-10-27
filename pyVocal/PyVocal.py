#!/usr/bin/env/python

import speech_recognition as sr
from ivy.ivy import IvyServer

class Agent(IvyServer):
    def __init__(self,name):
        IvyServer.__init__(self,"PyVocal")
        self.name = name
        self.start('127.255.255.255:2010')
        self.real_time_transcription()

    def real_time_transcription(self):
        recognizer = sr.Recognizer()
    
        with sr.Microphone() as source:
            print("Ajustement du bruit de fond... Veuillez patienter.")
            recognizer.adjust_for_ambient_noise(source, duration=2)
            print("Parlez maintenant...")

            while True:
                try:
                    audio = recognizer.listen(source, timeout=5)
                    text = recognizer.recognize_google(audio, language="fr-FR")
                    print("Vous avez dit : " + text)
                    s = ('PyVocal msg='+text).encode('iso-8859-1').decode('iso-8859-1')
                    self.send_msg(s)

                except sr.UnknownValueError:
                    print("Je n'ai pas compris ce que vous avez dit.")
                except sr.RequestError as e:
                    print(f"Erreur lors de la requête au service de reconnaissance vocale : {e}")
                except sr.exceptions.WaitTimeoutError as e:
                    print("Parle un jour non")
                except KeyboardInterrupt:
                    print("\nFin de la transcription en temps réel.")
                    break

if __name__ == "__main__":
    a = Agent("PyVocal")
