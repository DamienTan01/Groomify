import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve user data by email
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

  pickImage(ImageSource source) async{
    final ImagePicker _imagePicker = ImagePicker();
    //To select image from gallery
    XFile? _file = await _imagePicker.pickImage(source: source);
    //Check if the file has image
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Images Selected');
  }
}
