import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groomify/functions/auth_controller.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomer_details.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/profile.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestoreController = FirestoreController();

  int _selectedIndex = 0;
  String? email;
  String? profilePictureURL;
  String? salon;
  String? location;
  double minPrice = 0.0;
  double maxPrice = 0.0;
  List<String> groomerEmails = [];
  List<Map<String, dynamic>> appointmentData = [];
  List<String> fiveStarGroomerEmails = [];

  double rating = 0.0; // Variable to store groomer's rating

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
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchGroomerData();
    _loadAppointments();
  }

  Future<void> _fetchUserData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      final userData =
      await firestoreController.getUserDataByEmail(user.email!);
      if (userData != null) {
        setState(() {
          email = userData['email'];
        });
      }
    }
  }

  Future<void> _fetchGroomerData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      // Get the list of groomer emails
      groomerEmails = await firestoreController.getAllGroomerEmails();

      // Create lists to store data for each groomer
      List<String?> salonNames = [];
      List<String?> locations = [];
      List<double?> minPrices = [];
      List<double?> maxPrices = [];

      // Fetch groomer data for each email
      // Filter groomer emails with a rating of 5
      for (final email in groomerEmails) {
        final groomerData = await firestoreController.getGroomerDataByEmail(email);
        if (groomerData != null) {
          final rating = groomerData['rating'] ?? 0.0;
          if (rating == 5.0) {
            fiveStarGroomerEmails.add(email);
          }
        }
      }

      setState(() {
        // Update the state variables with the lists of data
        salon = salonNames.isNotEmpty ? salonNames[0] : null; // Assign the first element of the list
        location = locations.isNotEmpty ? locations[0] : null; // Assign the first element of the list
        minPrice = (minPrices.isNotEmpty ? minPrices[0] : 0.0)!; // Assign the first element of the list or a default value
        maxPrice = (maxPrices.isNotEmpty ? maxPrices[0] : 0.0)!; // Assign the first element of the list or a default value
      });
    }
  }

  void _loadAppointments() async {
    final user = AuthController.instance.auth.currentUser;
    final email = user!.email;
    if (email != null) {
      final appointments = await firestoreController.getAppointments(email);
      setState(() {
        appointmentData = appointments;
      });
    }
  }

  void _showEditDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) {
        final groomerEmail = appointment['email'];
        final selectedDate = appointment['selectedDate'];
        final formattedDate =
        DateFormat('d MMMM y').format(selectedDate.toDate());
        final salonName = appointment['salonName'];
        final selectedTime = appointment['selectedTime'];
        final selectedServices = appointment['selectedServices'];
        final docID = appointment['documentID'];

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xffF7D1CD),
          title: const Center(
            child: Text(
              'Complete Appointment :)',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$salonName',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Date: ',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Time: ',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$selectedTime',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Services: ',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${selectedServices.join(', ')}',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'Rate the Service!',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Rating: ',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        RatingBar.builder(
                          initialRating: 0,
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
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating; // Capture the rating
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff735D78),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                // Save the rating to the groomer based on their email
                await firestoreController.saveGroomerRating(groomerEmail, rating);

                // await firestoreController.moveAppointmentToHistoryUsers(email!, docID); // Pass the email and docID

                await firestoreController.moveAppointmentToHistoryGroomers(groomerEmail, docID); // Pass the email and docID

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Complete'),
            ),
            TextButton(
              onPressed: () {
                print('doc: $docID');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 20, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Groomify',
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
              }
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                // Text
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Appointments',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Appointments ListView
                Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  height: 450,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: appointmentData.length, // Show a maximum of 2 appointments
                    itemBuilder: (context, index) {
                      final appointment = appointmentData[index];
                      final selectedDate = appointment['selectedDate'];

                      // Format the date to "day, month, year" format
                      final formattedDate = DateFormat('d MMMM y').format(selectedDate.toDate());

                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${appointment['salonName']}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Date: ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedDate, // Use the formatted date here
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'Time: ',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${appointment['selectedTime']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Services: ',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${appointment['selectedServices'].join(', ')}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            // Add an edit IconButton
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(appointment);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                // Text
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Recommended Groomers',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Groomer Containers
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    height: 300, // Set the height of the horizontal ListView
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: fiveStarGroomerEmails.length,
                      itemBuilder: (context, index) {
                        final email = fiveStarGroomerEmails[index];
                        final groomerData = firestoreController.getGroomerDataByEmail(email);

                        return Container(
                          width: 190, // Set the width of each item in the horizontal ListView
                          margin: const EdgeInsets.only(left: 10), // Add some spacing between items
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return GroomerDetails(email: email);
                                    }));
                                  },
                                  child: // Inside the GridView builder, update the CircleAvatar widget to fetch the individual profile picture URL:
                                  Center(
                                    child: FutureBuilder<Map<String, dynamic>?>(
                                      future: groomerData,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          final data = snapshot.data;
                                          if (data != null) {
                                            final profilePictureURL = data['profile_picture'];
                                            return CircleAvatar(
                                              radius: 75, // Adjust the radius as needed
                                              backgroundImage: profilePictureURL != null
                                                  ? NetworkImage(profilePictureURL)
                                                  : const NetworkImage(
                                                'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                                              ),
                                            );
                                          }
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FutureBuilder<Map<String, dynamic>?>(
                                  future: groomerData,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      final data = snapshot.data;
                                      if (data != null) {
                                        final salonName = data['salonName'];
                                        final priceRange = data['price_range'];
                                        final minPrice = priceRange?['min_price'] ?? 'Not specified';
                                        final maxPrice = priceRange?['max_price'] ?? 'Not specified';
                                        final rating = data['rating'] ?? 0.0; // Use await to access the rating

                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                salonName ?? 'Unknown', // Add null check here
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Price Range (RM): \n${minPrice.toString()} -  ${maxPrice.toString()}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Rating: ',
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  RatingBar.builder(
                                                    initialRating: rating,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 16,
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
                                            ],
                                          ),
                                        );
                                      }
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
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


