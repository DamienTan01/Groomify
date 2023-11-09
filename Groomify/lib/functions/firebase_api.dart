import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request permission from user (Will prompt user)
    await _firebaseMessaging.requestPermission();

    // Fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // Print the token
    print('Token: $fCMToken');
  }
}