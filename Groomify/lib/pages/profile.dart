import 'package:flutter/material.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';
import 'package:groomify/pages/groomers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;
  bool showPassword = false;
  String? fullName;
  String? username;
  String? email;
  String? password;
  String? role;

  final firestoreController = FirestoreController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
    if (index == 1) {
      // Navigate to the Groomer page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GroomerPage()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  // Fetch user data from Firestore when the widget is initialized
  @override
  void initState() {
    super.initState();
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                offset: Offset(2, 2),
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
            icon: Icon(Icons.logout),
            iconSize: 35,
            color: Color(0xff735D78),
            onPressed: () {
              AuthController.instance.logout();
            },
          )
        ],
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          // Profile Picture
          Stack(
            children: [
              const CircleAvatar(
                radius: 90,
                backgroundImage: NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg'
                ),
              ),
              Positioned(
                bottom: -10,
                left: 140,
                child: IconButton(
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(Icons.add_a_photo),
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          //User Data
          Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        fullName ?? 'Loading...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        username ?? 'Loading...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  //Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        email ?? 'Loading...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  //Role
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        role ?? 'Loading...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
