import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomer_details.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';

class GroomerPage extends StatefulWidget {
  const GroomerPage({super.key});

  @override
  State<GroomerPage> createState() => _GroomerPageState();
}

class _GroomerPageState extends State<GroomerPage> {
  final firestoreController = FirestoreController();

  int _selectedIndex = 1;
  String? email;
  String? salon;
  String? location;
  late double minPrice;
  late double maxPrice;
  List<String> groomerEmails = [];

  // List to store groomer data
  List<Map<String, dynamic>> groomerDataList = [];

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
      for (final email in groomerEmails) {
        final userData = await firestoreController.getGroomerDataByEmail(email);
        if (userData != null) {
          salonNames.add(userData['salonName']);
          locations.add(userData['location']);

          // Retrieve and update price range
          final priceRange = userData['price_range'];
          if (priceRange != null) {
            minPrices.add(priceRange['min_price']);
            maxPrices.add(priceRange['max_price']);
          } else {
            minPrices.add(null);
            maxPrices.add(null);
          }
        }
      }

      // Now you have lists containing the data for each groomer
      // You can use these lists to display or process the data as needed.
      setState(() {
        // Update the state variables with the lists of data
        salon = salonNames as String?;
        location = locations as String?;
        minPrice = minPrices as double;
        maxPrice = maxPrices as double;
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
              }
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIconColor: Color(0xff735D78),
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search for Groomers',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Groomer Containers
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.85,
                ),
                itemCount: groomerEmails.length,
                itemBuilder: (context, index) {
                  final email = groomerEmails[index];
                  final userData = firestoreController.getGroomerDataByEmail(email);

                  return Container(
                    width: 190,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: <Widget>[
                        //Image
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const GroomerDetails(); // Replace with the actual screen you want to navigate to
                            }));
                          },
                          child: Container(
                            width: 190,
                            height: 130,
                            decoration: BoxDecoration(
                              color: const Color(0xffD1B3C4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Item',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Salon name and Price Range
                        FutureBuilder<Map<String, dynamic>?>(
                          future: userData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              final data = snapshot.data;
                              if (data != null) {
                                final salonName = data['salonName'];
                                final priceRange = data['price_range'];
                                final minPrice = priceRange?['min_price'] ?? 'Not specified';
                                final maxPrice = priceRange?['max_price'] ?? 'Not specified';
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        salonName,
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
