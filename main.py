import pyrebase
import time

# //solopin14,15

import RPi.GPIO as GPIO   
import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

GPIO.setup(14, GPIO.OUT)
GPIO.setup(15, GPIO.OUT)
GPIO.setup(17, GPIO.OUT)
GPIO.setup(18, GPIO.OUT)

def on_led(pin_no):
    GPIO.output(pin_no, GPIO.HIGH)
    print("LED on")

def off_led(pin_no):
    print("LED off")
    GPIO.output(pin_no, GPIO.LOW)

firebaseConfig = { 

}

fb = pyrebase.initialize_app(firebaseConfig)
db = fb.database()
print("Connection to firebase successful.")

WRCtoAmareChautaro = db.child('/routes/WRCtoAmareChautaro').get().val()
WRCtoRegmiHomes = db.child('/routes/WRCtoRegmiHomes').get().val()
WRCtoLamachour = db.child('/routes/WRCtoLamachour').get().val()

def returnMatches(a,b):
    return len(list(set(a) & set(b)))

def stream_handler(message):
    off_led(14)
    off_led(15)
    off_led(17)
    off_led(18)
    user_route = message["data"]
    if user_route:
        match1 = (returnMatches(WRCtoAmareChautaro, user_route))
        match2 = (returnMatches(WRCtoRegmiHomes, user_route))
        match3 = (returnMatches(WRCtoLamachour, user_route))
        match3 += 2
        # print("Match1: ", match1)
        # print("Match2: ", match2)
        # # match3 = (returnMatches(WRCtoLamachour, user_route))
        # if user_route[-2:]==[28.240610000000014,83.98776999999998]:
        #     on_led(17)
        #     print("End Location is Mustang Chowk")
        # elif user_route[-2:] == [28.234480000000023,83.98306999999996]:
        #     on_led(15)
        #     on_led(14)
        #     print("End location is Archalbot")
        # elif user_route[-2:] == [28.249220000000008,83.98964999999998]:
        #     on_led(18)
        #     on_led(14)
        #     print("End location is Gurkha welfare trust")
        # else:
        #     print("Route not in database")
        print(match1, match2, match3)
        if (match1>2 and match2>2 and match3>2):
            if (match1 > match2) and (match1 > match3):
                on_led(15)
                print("AmareChautaro")
            # pin 18 blink
            elif (match2 > match1) and (match2 > match3):
                on_led(18)
                on_led(14)
                print("RegmiHomes")
            else:
                on_led(14)
                on_led(17)
                print("Lamachour")
        else:
            print("Lights not installed in the route!")

try:
    my_stream = db.child("users/test@test,com/routes").stream(stream_handler)
except Exception as e:
    print(e)

