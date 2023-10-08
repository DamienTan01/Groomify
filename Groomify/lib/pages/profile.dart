import 'package:flutter/material.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPassword = false;
  int _selectedIndex = 2;
  String? fullName;
  String? username;
  String? email;
  String? password;

  final firestoreController = FirestoreController();

  // Fetch user data from Firestore when the widget is initialized
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
    }
    if (index == 1) {
      // Navigate to the Profile page
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  Future<void> _fetchUserData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      final userData = await firestoreController.getUserDataByEmail(user.email!);
      if (userData != null) {
        setState(() {
          fullName = userData['fullName'];
          username = userData['username'];
          email = userData['email'];
          password = userData['password'];
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
        backgroundColor: Color(0xffD1B3C4),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            //User Data
            Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Full Name:',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          email ?? 'Loading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password:',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the TextField and IconButton horizontally
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: password ?? 'Loading...'),
                                  style: TextStyle(fontSize: 20),
                                  readOnly: true, // Make the field read-only
                                  obscureText: !showPassword, // Hide/show password based on the showPassword state
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  showPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword; // Toggle password visibility
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff735D78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {

                  },
                  child: Text('Change Password'),
                ),
              ),
            ),
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
