# flutter_instamojo

A new Flutter plugin for instamojo payment gateway and the idea has been taken from instamojo's Android SDK
(https://github.com/Instamojo/instamojo-android-sdk), there are still some things needs to be implemented and to be tested. 
Will ne updating the whole procedure and the dependencies required to use this in a short time.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and iOS is working fine. 

## Order creation server

In order to use the Instamojo payment gateway, you should set up a server containing the live and test keys of your instamojo's panel, so as it would be used to create the order id. 

I have taken their go server side code ("https://github.com/Instamojo/sample-sdk-server") as an example and made some of the API(s) in dart and have deployed it to heroku. 
"https://instamojo-dart-server.herokuapp.com/order" // Please dont use this.

But that server has the keys of my personal Instamojo's panel. 

So Please if you want to try before deploying the order creation api to the server, please use 
instamojo's sample order creation API "https://sample-sdk-server.instamojo.com/order".

And fro server setup, you can have a look at [instamojo dart API] (https://github.com/kushalmahapatro/instamojo_dart_apis)

