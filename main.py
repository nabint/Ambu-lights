from firebase import firebase

print("Connectiog to firebase....")
firebase = firebase.FirebaseApplication('https://ambu-lights.firebaseio.com', None)
print("Connection to firebase successful.")