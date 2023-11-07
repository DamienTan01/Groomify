import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  // Update the 'salon' field in Firestore
  Future<void> updateGroomingSalon(String salon, String email) async {
    try {
      final userRef = _firestore.collection('groomers').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();

        // Update the 'salon' field with the provided salon name
        userData['salonName'] = salon;

        // Update the document in Firestore
        userDoc.reference.update(userData);
      }
    } catch (e) {
      print('Error updating grooming salon: $e');
    }
  }

  // Update the 'salon' field in Firestore
  Future<void> updateSalonLocation(String location, String email) async {
    try {
      final userRef = _firestore.collection('groomers').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();

        // Update the 'location' field with the provided salon location
        userData['location'] = location;

        // Update the document in Firestore
        userDoc.reference.update(userData);
      }
    } catch (e) {
      print('Error updating salon location: $e');
    }
  }

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

  // Update the 'price_range' field in Firestore
  Future<void> updatePriceRange(double minPrice, double maxPrice, String email) async {
    try {
      final userRef = _firestore.collection('groomers').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();

        // Check if 'price_range' field is present
        if (userData.containsKey('price_range')) {
          // If it's present, update the existing 'min_price' and 'max_price' values
          userData['price_range']['min_price'] = minPrice;
          userData['price_range']['max_price'] = maxPrice;
        } else {
          // If 'price_range' field is not present, create it and save the price range
          userData['price_range'] = {
            'min_price': minPrice,
            'max_price': maxPrice,
          };
        }

        // Update the document in Firestore
        userDoc.reference.update(userData);
      }
    } catch (e) {
      print('Error updating price range: $e');
    }
  }

  // Retrieve all groomer emails by going through 'Groomers' collection in Firestore
  Future<List<String>> getAllGroomerEmails() async {
    try {
      final groomersCollection = _firestore.collection('groomers');
      final querySnapshot = await groomersCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the documents and extract the email field from each document.
        List<String> emails = querySnapshot.docs.map((doc) {
          final userData = doc.data();
          return userData['email'] as String;
        }).toList();

        return emails;
      } else {
        return []; // No groomer documents found
      }
    } catch (e) {
      print('Error fetching groomer emails: $e');
      return [];
    }
  }

  Future<void> uploadAppointmentInfo(
      BuildContext context, // Pass the context from the calling function
      String email, // The user's email
      String salon, // Salon Name
      DateTime selectedDate, // The selected booking date
      TimeOfDay selectedTime, // The selected booking time
      List<String> selectedServices, // List of selected services
      ) async {
    try {
      final userRef = _firestore.collection('users').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data();

        // Create a Map with the booking information
        final appointmentData = {
          'salonName': salon,
          'selectedDate': selectedDate.toUtc(), // Convert to UTC to store timezone-independent datetime
          'selectedTime': selectedTime.format(context), // Format the time as a string using the provided context
          'selectedServices': selectedServices,
        };

        // Add the booking information to the 'bookings' field in the user's document
        userData['appointments'] = appointmentData;

        // Update the document in Firestore
        userDoc.reference.update(userData);
      }
    } catch (e) {
      print('Error uploading appointment information: $e');
    }
  }

  // Add a booking to the user's booking history
  Future<void> addAppointmentToHistory(String email, Map<String, dynamic> appointmentData) async {
    try {
      final userRef = _firestore.collection('users').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;

        // Get a reference to the booking history subcollection
        final appointmentHistoryCollection = userDoc.reference.collection('appointmentHistory');

        // Add the booking data as a new document in the booking history subcollection
        await appointmentHistoryCollection.add(appointmentData);
      }
    } catch (e) {
      print('Error adding appointment to history: $e');
    }
  }

  // Retrieve booking history for the current logged-in user
  Future<List<Map<String, dynamic>>> getBookingHistory(String email) async {
    try {
      final userRef = _firestore.collection('users').where('email', isEqualTo: email);
      final querySnapshot = await userRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;

        // Get a reference to the booking history subcollection
        final appointmentHistoryCollection = userDoc.reference.collection('appointmentHistory');

        final appointmentHistoryQuerySnapshot = await appointmentHistoryCollection.get();

        if (appointmentHistoryQuerySnapshot.docs.isNotEmpty) {
          // Iterate through the documents and extract the booking history data.
          List<Map<String, dynamic>> bookingHistory = appointmentHistoryQuerySnapshot.docs
              .map((doc) {
            final appointmentData = doc.data();
            return appointmentData;
          })
              .toList();

          return bookingHistory;
        } else {
          return []; // No booking history documents found
        }
      } else {
        return []; // User document not found
      }
    } catch (e) {
      print('Error fetching booking history: $e');
      return [];
    }
  }

  Future<void> saveGroomerRating(String groomerEmail, double rating) async {
    try {
      // Reference to the groomer's document in Firestore
      final groomerQuerySnapshot = await _firestore
          .collection('groomers')
          .where('email', isEqualTo: groomerEmail)
          .get();

      if (groomerQuerySnapshot.docs.isNotEmpty) {
        final groomerDoc = groomerQuerySnapshot.docs.first;
        final currentRating = groomerDoc.data()['rating'] ?? 0.0;
        final numberOfRatings = groomerDoc.data()['numberOfRatings'] ?? 0;

        // Calculate the new average rating based on the new rating and the number of ratings
        final newRating = (currentRating * numberOfRatings + rating) / (numberOfRatings + 1);

        // Update the groomer's document with the new rating and the incremented number of ratings
        await groomerDoc.reference.update({
          'rating': newRating,
          'numberOfRatings': FieldValue.increment(1),
        });
      } else {
        print('Groomer not found with email: $groomerEmail');
      }
    } catch (error) {
      print('Error saving groomer rating: $error');
    }
  }
}
