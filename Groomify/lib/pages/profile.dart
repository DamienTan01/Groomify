import 'package:flutter/material.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/functions/auth_controller.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/groomers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController contactController = TextEditingController();
  int _selectedIndex = 2;
  bool isEditingContact = false;
  String? fullName;
  String? username;
  String? email;
  String? password;
  String? role;
  String? contact;
  String? tempContact;
  String? profilePictureURL;

  final firestoreController = FirestoreController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
    if (index == 1) {
      // Navigate to the Groomer page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const GroomerPage()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  // Fetch user data from Firestore when the widget is initialized
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchProfilePicture();
  }

  void refreshPage() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      final userData =
          await firestoreController.getUserDataByEmail(user.email!);
      if (userData != null) {
        setState(() {
          fullName = userData['fullName'];
          username = userData['username'];
          email = userData['email'];
          password = userData['password'];
          role = userData['role'];
          contact = userData['contactNo'];
          profilePictureURL = userData['profile_picture'];
        });
      }
    }
  }

  Future<void> _fetchProfilePicture() async {
    final profilePictureURL =
        await firestoreController.getGroomerProfilePictureURL(email!);
    if (profilePictureURL != null) {
      setState(() {
        this.profilePictureURL = profilePictureURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 3.0,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xffD1B3C4),
        actions: [
          // Log out Button
          IconButton(
            icon: const Icon(Icons.logout),
            iconSize: 35,
            color: const Color(0xff735D78),
            onPressed: () {
              AuthController.instance.logout();
            },
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: profilePictureURL != null
                      ? NetworkImage(profilePictureURL!)
                      : const NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                        ),
                ),
                Positioned(
                  bottom: -10,
                  left: 120,
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      firestoreController.uploadProfilePicture(email!);
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const SizedBox(height: 50),
            //User Data
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full Name:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        fullName ?? 'Loading...',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        username ?? 'Loading...',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  //Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        email ?? 'Loading...',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Contact Number
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Number:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isEditingContact)
                              Text(
                                isEditingContact
                                    ? contactController.text
                                    : formatPhoneNumber(contact),
                                style: const TextStyle(fontSize: 20),
                              )
                            else
                              Expanded(
                                child: TextFormField(
                                  controller: contactController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Contact',
                                  ),
                                  // Add validation to ensure the entered text is a valid contact number
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      return null; // Return null if the input is valid
                                    } else {
                                      return 'Please enter a valid contact number';
                                    }
                                  },
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                  isEditingContact ? Icons.check : Icons.edit),
                              onPressed: () {
                                // Toggle editing mode
                                setState(() {
                                  if (isEditingContact) {
                                    // Save the edited location and exit editing mode
                                    contact = contactController.text;
                                  } else {
                                    // Store the existing location value in tempLocation
                                    tempContact = contact;
                                  }
                                  isEditingContact = !isEditingContact;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(
                    right: 20), // Adjust the margin as needed
                child: SizedBox(
                  width: w * 0.3,
                  height: h * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color(0xff735D78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      // Update the 'contactNo' field in Firestore
                      await firestoreController.updateContact(contact!, email!);

                      refreshPage();
                    },
                    child: const Text('Update'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Function to format the phone number with hyphen after the first 3 digits
String formatPhoneNumber(String? phoneNumber) {
  if (phoneNumber != null && phoneNumber.isNotEmpty) {
    // Insert hyphen after the first 3 digits
    return phoneNumber.replaceRange(3, 3, '-');
  } else {
    return '';
  }
}
