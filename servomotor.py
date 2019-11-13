import RPi.GPIO as GPIO
import time
import pyrebase

#Firebase Configuration
config = {
        "apiKey": "apiKey",
        "authDomain": "https://lights1.firebaseapp.com",
        "databaseURL": "https://lights1.firebaseio.com",
        "storageBucket" : "https://lights1.appspot.com"
}

firebase = pyrebase.initialize_app(config)

#GPIO Setup
servoPIN = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(servoPIN, GPIO.OUT)

p = GPIO.PWM(servoPIN, 50) #GPIO control pin 17 for PWM with 50Hz
p.start(0) # Initialization

#Firebase Database Initialization
db = firebase.database()

try:
    while True:
        #See if servo motor is on or off
        servomotor = db.child("servomotor").get()

        #Sort through children of motor (if applicable)
        for user in servomotor.each():
            if (user.val() == "ON"):
                p.ChangeDutyCycle(2.5)  #Rotate CC for 2 seconds
                time.sleep(2)
                print("hello")
            else:
                p.ChangeDutyCycle(12.5) #Rotate CCW for 2 seconds
                time.sleep(2)
                print("hello2")
except KeyboardInterrupt:
    p.stop()
    GPIO.cleanup()
