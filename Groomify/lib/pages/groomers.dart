import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
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
  int _selectedIndex = 1;

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
          children: [
            const SizedBox(height: 20),
            //Search Bar
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
            Row(
              children: [
                Container(
                  width: 190,
                  height: 200,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pet Shop',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Rating: 5 stars',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
