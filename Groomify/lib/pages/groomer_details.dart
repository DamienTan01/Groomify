import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';

class GroomerDetails extends StatefulWidget {
  const GroomerDetails({super.key});

  @override
  State<GroomerDetails> createState() => _GroomerDetailsState();
}

class _GroomerDetailsState extends State<GroomerDetails> {
  final firestoreController = FirestoreController();
  int _selectedIndex = 1;
  String? fullName;
  String? username;
  String? email;
  String? password;
  String? role;
  String? salon;
  String? location;
  String? profilePictureURL;
  double minPrice = 0.0;
  double maxPrice = 100.0;

  @override
  void initState() {
    super.initState();
    _fetchGroomerData();
    _fetchProfilePicture();
  }

  void refreshPage() {
    _fetchGroomerData();
  }

  Future<void> _fetchGroomerData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      final userData =
      await firestoreController.getGroomerDataByEmail(user.email!);
      if (userData != null) {
        setState(() {
          fullName = userData['fullName'];
          username = userData['username'];
          email = userData['email'];
          password = userData['password'];
          role = userData['role'];
          salon = userData['salonName'];
          location = userData['location'];
          profilePictureURL = userData['profile_picture'];


          // Retrieve and update price range
          final priceRange = userData['price_range'];
          if (priceRange != null) {
            minPrice = priceRange['min_price'] ?? minPrice;
            maxPrice = priceRange['max_price'] ?? maxPrice;
          }
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
    if (index == 1) {
      // Navigate to the Groomer page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroomerPage()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  Future<void> _fetchProfilePicture() async {
    final profilePictureURL =
    await firestoreController.getProfilePictureURL(email!);
    if (profilePictureURL != null) {
      setState(() {
        this.profilePictureURL = profilePictureURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groomers',
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
          //Log out Button
          IconButton(
              icon: const Icon(Icons.logout),
              iconSize: 35,
              color: const Color(0xff735D78),
              onPressed: () {
                AuthController.instance.logout();
              }
          )
        ],
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff735D78)),
      ),
      body: const SingleChildScrollView (
        child: Column(
          children: [
            SizedBox(height: 20),
            //Groomer Details

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
