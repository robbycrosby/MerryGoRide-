import stripe
from flask import Flask
from flask import request
from flask import json
import SimpleHTTPServer
import SocketServer
import logging
import cgi

import sys


if len(sys.argv) > 2:
    PORT = int(sys.argv[2])
    I = sys.argv[1]
elif len(sys.argv) > 1:
    PORT = int(sys.argv[1])
    I = ""
else:
    PORT = 8000
    I = ""
 
app = Flask(__name__)
print('Server Starting...')
print('Ready to Accept Payments')
#1
class ServerHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
        @app.route('/pay', methods=['POST'])
        def pay():
          print "Charge Recieved"
          #2
          # Set this to your Stripe secret key (use your test key!)
          stripe.api_key = "sk_test_5eEaLZlg6JZMtRTzBAFR4Ztu"
         
          #3
          # Parse the request as JSON
          json = request.get_json(force=True)
         
          # Get the credit card details
          token = json['stripeToken']
          amount = json['amount']
          description = json['description']
          print "Processing Charge"
          print "Charge is for %d cents" % amount
          # Create the charge on Stripe's servers - this will charge the user's card
          try:
            #4
            charge = stripe.Charge.create(
                
                                          amount=amount,
                                          currency="usd",
                                          card=token,
                                          description=description
                                          )
          except stripe.CardError, e:
            # The card has been declined
            pass
         
          #5
            return "Success!"
            print "Charge complete! Returning to Info to MerryGoRide for iOS"
if __name__ == '__main__':
    app.run(debug=True, host= '0.0.0.0')
