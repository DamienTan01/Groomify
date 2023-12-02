import 'package:flutter/material.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/appointment.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GroomerDetails extends StatefulWidget {
  final String email; // Pass the groomer's email as a parameter to this widget

  const GroomerDetails({required this.email, Key? key}) : super(key: key);

  @override
  State<GroomerDetails> createState() => _GroomerDetailsState();
}

class _GroomerDetailsState extends State<GroomerDetails> {
  final firestoreController = FirestoreController();
  int _selectedIndex = 1;
  String? email;
  String? fullName;
  String? username;
  String? salon;
  String? location;
  String? profilePictureURL;
  String? contact;
  double minPrice = 0.0;
  double maxPrice = 100.0;
  List<String> services = [];
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchGroomerData();
  }

  void refreshPage() {
    _fetchGroomerData();
  }

  Future<void> _fetchGroomerData() async {
    final groomerData = await firestoreController.getGroomerDataByEmail(widget.email);
    if (groomerData != null) {
      setState(() {
        fullName = groomerData['fullName'];
        username = groomerData['username'];
        salon = groomerData['salonName'];
        location = groomerData['location'];
        profilePictureURL = groomerData['profile_picture'];
        email = groomerData['email'];
        final dynamic ratingData = groomerData['rating'];
        rating = ratingData is double ? ratingData : 0.0;
        contact = groomerData['contactNo'];

        if (groomerData['services'] != null) {
          services = List<String>.from(groomerData['services']);
        }

        // Retrieve and update price range
        final priceRange = groomerData['price_range'];
        if (priceRange != null) {
          minPrice = priceRange['min_price'] ?? minPrice;
          maxPrice = priceRange['max_price'] ?? maxPrice;
        }
      });
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    // Define the number of rows and columns
    const int rowCount = 3;
    const int colCount = 3;

    // Create a list of TableCell widgets for each service
    final List<TableCell> serviceCells = List.generate(
      rowCount * colCount,
          (index) {
        if (index < services.length) {
          return TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: Text(
                services[index],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        } else {
          // Return empty TableCell for remaining cells
          return TableCell(
            child: Container(),
          );
        }
      },
    );

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
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff735D78)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Groomer Details
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 90,
                backgroundImage: profilePictureURL != null
                    ? NetworkImage(profilePictureURL!)
                    : const NetworkImage(
                  'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display Groomer Details
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Salon Name
                    Center(
                      child: Text(
                        salon ?? 'Loading...',
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Rating
                    Row(
                      children: [
                        const Text(
                          'Rating: ',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        RatingBar.builder(
                          initialRating: rating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (newRating) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Location
                    const Text(
                      'Location: ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      location ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    // Full Name
                    const Text(
                      'Full Name: ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      fullName ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    // Username
                    const Text(
                      'Username: ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      username ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    // Contact
                    const Text(
                      'Contact Number: ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formatPhoneNumber(contact) ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    // Price Range
                    const Text(
                      'Price Range (RM): ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$minPrice - $maxPrice',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    // Services
                    const Text(
                      'Services: ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: List.generate(
                        rowCount,
                            (rowIndex) {
                          return TableRow(
                            children: serviceCells.sublist(
                              rowIndex * colCount,
                              (rowIndex + 1) * colCount,
                            ).map((cell) => TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4, right: 4), // Add left padding
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: cell.child, // Access the child of the TableCell
                                ),
                              ),
                            )).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: w * 0.36,
                  height: h * 0.06,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AppointmentPage(
                              groomerServices: services,
                              salon: salon!,
                              email: email!,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Book Now'),
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
