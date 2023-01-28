import datetime
import requests
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import google.cloud.firestore
import time

# Use a service account
cred = credentials.Certificate('credentials.json')
firebase_admin.initialize_app(cred)

db: google.cloud.firestore.Client  = firestore.client()


url = 'https://www.mit.gl/wp-content/themes/mitgl/webservice.php?type=Departures&icao=BGJN'


while True:
    response = requests.get(url)
    data = None
    if response.status_code == 200:
        print('Success!')
        data = response.json()
    elif response.status_code == 404:
        print('Not Found.')

    for flight in data:
        #change the "estimated" and "planned" keys from string to datetime from ISO 8601 format
        if flight['Estimated'] != None:
            flight['Estimated'] = datetime.datetime.fromisoformat(flight['Estimated'])
        if flight['Planned'] != None:
            flight['Planned'] = datetime.datetime.fromisoformat(flight['Planned'])
        #check if the flight is already in the database
        doc_ref = db.collection(u'flights').document(flight['FlightHash'])
        doc = doc_ref.get()
        doc_ref.set(flight)
    #sleep for 5 minutes
    time.sleep(300)

    
        
    


