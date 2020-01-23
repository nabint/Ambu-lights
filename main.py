import pyrebase

firebaseConfig = {
 
}

fb = pyrebase.initialize_app(firebaseConfig)
db = fb.database()
print("Connection to firebase successful.")

WRCtoArchalBot = db.child('/routes/WRCtoArchalBot').get().val()
WRCtoMustangChowk = db.child('/routes/WRCtoMustangChowk').get().val()

def returnMatches(a,b):
    return len(list(set(a) & set(b)))

def stream_handler(message):
    user_route = message["data"]
    if user_route:
        match1 = (returnMatches(WRCtoArchalBot, user_route))
        match2 = (returnMatches(WRCtoMustangChowk, user_route))
        if (match1 > match2):
            print("ArchalBot")
        else:
            print("MustangChowk")

my_stream = db.child("users/test@test,com/routes").stream(stream_handler)