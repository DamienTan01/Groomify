import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of Firebase Messsaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)


    // Fetch FCM token for this device


    // print the token


    // function to handle received messages
  }
}