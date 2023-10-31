import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:groomify/pages/groomer_profile.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve data by email (Users)
  Future<Map<String, dynamic>?> getUserDataByEmail(String email) async {
    try {
      final QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        return userData;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  //Upload profile picture (Users)
  Future<void> uploadProfilePicture(String email) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageReference = FirebaseStorage.instance.ref().child('profile_picture/$email.jpg');
      final uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        final imageUrl = await storageReference.getDownloadURL();

        // Save the image URL to Firestore under the 'profile_picture' field for the user with the specified email.
        final userRef = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email);
        userRef.get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            final userDoc = querySnapshot.docs.first;
            userDoc.reference.update({'profile_picture': imageUrl});
          }
        });
      });
    }
  }

  //Retrieve image url (Users)
  Future<String?> getProfilePictureURL(String email) async {
    try {
      final userRef = _firestore.collection('users').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        return userData['profile_picture'] as String?;
      }
      return null; // User not found
    } catch (e) {
      print('Error fetching profile picture URL: $e');
      return null;
    }
  }

  // Retrieve data by email (Groomers)
  Future<Map<String, dynamic>?> getGroomerDataByEmail(String email) async {
    try {
      final QuerySnapshot userSnapshot = await _firestore
          .collection('groomers')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        return userData;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  //Upload profile picture (Groomers)
  Future<void> uploadGroomerProfilePicture(String email) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageReference = FirebaseStorage.instance.ref().child('profile_picture/$email.jpg');
      final uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        final imageUrl = await storageReference.getDownloadURL();

        // Save the image URL to Firestore under the 'profile_picture' field for the user with the specified email.
        final userRef = FirebaseFirestore.instance.collection('groomers').where('email', isEqualTo: email);
        userRef.get().then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            final userDoc = querySnapshot.docs.first;
            userDoc.reference.update({'profile_picture': imageUrl});
          }
        });
      });
    }
  }

  //Retrieve image url (Groomers)
  Future<String?> getGroomerProfilePictureURL(String email) async {
    try {
      final userRef = _firestore.collection('groomers').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();
        return userData['profile_picture'] as String?;
      }
      return null; // User not found
    } catch (e) {
      print('Error fetching profile picture URL: $e');
      return null;
    }
  }

  // Retrieve the 'role' field for a user by email
  Future<String?> getUserRoleByEmail(String email) async {
    try {
      final userRef = _firestore.collection('users').where('email', isEqualTo: email);
      final groomerRef = _firestore.collection('groomers').where('email', isEqualTo: email);

      final userQuerySnapshot = await userRef.get();
      final groomerQuerySnapshot = await groomerRef.get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDoc = userQuerySnapshot.docs.first;
        final userData = userDoc.data();
        return userData['role'] as String?;
      } else if (groomerQuerySnapshot.docs.isNotEmpty) {
        final groomerDoc = groomerQuerySnapshot.docs.first;
        final groomerData = groomerDoc.data();
        return groomerData['role'] as String?;
      }

      return null; // User not found in either collection or 'role' field is not set
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

// ... (other methods)

  // Update the 'services' field in Firestore based on checkbox values
  Future<void> updateServices(List<CheckboxListTileModel> checkboxes, String email) async {
    try {
      final userRef = _firestore.collection('groomers').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();

        // Create a list of selected services
        final List<String> selectedServices = [];
        for (int index = 0; index < checkboxes.length; index++) {
          if (checkboxes[index].isSelected) {
            selectedServices.add(checkboxes[index].title);
          }
        }

        // Update the 'services' field with the selected services
        userData['services'] = selectedServices;

        // Update the document in Firestore
        userDoc.reference.update(userData);
      }
    } catch (e) {
      print('Error updating services: $e');
    }
  }
}
