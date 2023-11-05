import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPage();
}

class _BookingPage extends State<BookingPage> {
  final firestoreController = FirestoreController();
  int _selectedIndex = 1;
  String? fullName;
  String? username;
  String? salon;
  String? location;
  String? profilePictureURL;
  double minPrice = 0.0;
  double maxPrice = 100.0;
  List<String> services = [];

  @override
  void initState() {
    super.initState();
    // _fetchGroomerData();
  }

  // Future<void> _fetchGroomerData() async {
  //   final userData = await firestoreController.getGroomerDataByEmail(email!);
  //   if (userData != null) {
  //     setState(() {
  //       fullName = userData['fullName'];
  //       username = userData['username'];
  //       salon = userData['salonName'];
  //       location = userData['location'];
  //       profilePictureURL = userData['profile_picture'];
  //
  //       if (userData['services'] != null) {
  //         services = List<String>.from(userData['services']);
  //       }
  //
  //       // Retrieve and update price range
  //       final priceRange = userData['price_range'];
  //       if (priceRange != null) {
  //         minPrice = priceRange['min_price'] ?? minPrice;
  //         maxPrice = priceRange['max_price'] ?? maxPrice;
  //       }
  //     });
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking',
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
        iconTheme: const IconThemeData(color: Color(0xff735D78)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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