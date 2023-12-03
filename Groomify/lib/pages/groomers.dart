import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groomify/functions/auth_controller.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomer_details.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';

class GroomerPage extends StatefulWidget {
  const GroomerPage({Key? key}) : super(key: key);

  @override
  State<GroomerPage> createState() => _GroomerPageState();
}

class _GroomerPageState extends State<GroomerPage> {
  final firestoreController = FirestoreController();
  TextEditingController searchController = TextEditingController();

  int _selectedIndex = 1;
  String? email;
  String? profilePictureURL;
  String? salon;
  String? location;
  double minPrice = 0.0;
  double maxPrice = 0.0;
  List<String> groomerEmails = [];
  List<String> filteredGroomerEmails = [];
  // List to store groomer data
  List<Map<String, dynamic>> groomerDataList = [];

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

  Future<void> _fetchGroomerData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      // Get the list of groomer emails
      groomerEmails = await firestoreController.getAllGroomerEmails();

      // Initialize filteredGroomerEmails with all groomers
      filteredGroomerEmails = List.from(groomerEmails);

      // Create lists to store data for each groomer
      List<String?> salonNames = [];
      List<String?> locations = [];
      List<double?> minPrices = [];
      List<double?> maxPrices = [];

      // Fetch groomer data for each email
      for (final email in groomerEmails) {
        final userData = await firestoreController.getGroomerDataByEmail(email);
        if (userData != null) {
          salonNames.add(userData['salonName'] ?? 'Unknown');
          locations.add(userData['location'] ?? 'Unknown');

          final priceRange = userData['price_range'];
          if (priceRange != null) {
            minPrices.add(priceRange['min_price'] ?? 0.0);
            maxPrices.add(priceRange['max_price'] ?? 0.0);
          } else {
            minPrices.add(0.0);
            maxPrices.add(0.0);
          }
        } else {
          // Handle the case where userData is null, e.g., set default values
          salonNames.add('Unknown');
          locations.add('Unknown');
          minPrices.add(0.0);
          maxPrices.add(0.0);
        }
      }

      // Now you have lists containing the data for each groomer
      // You can use these lists to display or process the data as needed.
      setState(() {
        // Update the state variables with the lists of data
        salon = salonNames.isNotEmpty
            ? salonNames[0]
            : null; // Assign the first element of the list
        location = locations.isNotEmpty
            ? locations[0]
            : null; // Assign the first element of the list
        minPrice = (minPrices.isNotEmpty
            ? minPrices[0]
            : 0.0)!; // Assign the first element of the list or a default value
        maxPrice = (maxPrices.isNotEmpty
            ? maxPrices[0]
            : 0.0)!; // Assign the first element of the list or a default value
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGroomerData();
  }

  void refreshPage() {
    _fetchGroomerData();
  }

  // Function to filter groomers based on search query
  Future<void> filterGroomers(String query) async {
    filteredGroomerEmails.clear();
    final Set<String> uniqueSalonNames = Set(); // To store unique salon names

    if (query.isEmpty) {
      filteredGroomerEmails.addAll(groomerEmails);
    } else {
      for (final email in groomerEmails) {
        final groomerData =
            await firestoreController.getGroomerDataByEmail(email);
        if (groomerData != null) {
          final salonName = groomerData['salonName']?.toString() ?? '';
          if (salonName.isNotEmpty &&
              salonName.toLowerCase().contains(query.toLowerCase())) {
            // Check if salonName is not empty and contains the query
            if (uniqueSalonNames.add(salonName)) {
              // Only add if it's a unique salon name
              filteredGroomerEmails.add(email);
            }
          }
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            },
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          // Search Bar
          Center(
            child: Container(
              width: 350,
              height: 50, // Set the height of the search bar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  // Update the UI when the search query changes
                  filterGroomers(query);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for Groomers',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Groomer Containers
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredGroomerEmails.length,
                  itemBuilder: (context, index) {
                    final email = filteredGroomerEmails[index];
                    final groomerData =
                        firestoreController.getGroomerDataByEmail(email);

                    return SizedBox(
                      width: 190,
                      child: Column(
                        children: <Widget>[
                          //Image
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GroomerDetails(email: email);
                              }));
                            },
                            child: // Inside the GridView builder, update the CircleAvatar widget to fetch the individual profile picture URL:
                                Center(
                              child: FutureBuilder<Map<String, dynamic>?>(
                                future: groomerData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final data = snapshot.data;
                                    if (data != null) {
                                      final profilePictureURL =
                                          data['profile_picture'];
                                      return CircleAvatar(
                                        radius:
                                            75, // Adjust the radius as needed
                                        backgroundImage: profilePictureURL !=
                                                null
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
                          // Groomer Details
                          FutureBuilder<Map<String, dynamic>?>(
                            future: groomerData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final data = snapshot.data;
                                if (data != null) {
                                  final salonName = data['salonName'];
                                  final priceRange = data['price_range'];
                                  final minPrice = priceRange?['min_price'] ??
                                      'Not specified';
                                  final maxPrice = priceRange?['max_price'] ??
                                      'Not specified';
                                  final rating = data['rating'];
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          salonName ??
                                              'Unknown', // Add null check here
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
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            RatingBar.builder(
                                              initialRating: rating ?? 0.0,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 16,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
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
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
