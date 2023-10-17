import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/profile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
    }
    if (index == 1) {
      // Navigate to the Groomer page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroomerPage()));
    }
    if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
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
          'Groomify',
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
          //Log out Button
          IconButton(
              icon: Icon(Icons.logout),
              iconSize: 35,
              color: Color(0xff735D78),
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
            //Text
            Column(
              children: [
                //Ads
               SingleChildScrollView(
                 child: Container(
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.black)
                   ),
                   height: 140,
                 ),
               ),
                SizedBox(height: 10),
                //Text
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Grooming Services',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //Services
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  children: [
                    _buildServiceButton('Pet Bathing', Icons.bathtub),
                    _buildServiceButton('Haircuts', Icons.content_cut),
                    _buildServiceButton('Nail Trim', Icons.content_paste),
                    _buildServiceButton('Teeth Clean', Icons.brush),
                    _buildServiceButton('Ear Clean', Icons.hearing),
                    _buildServiceButton('Flea & Tick Treatment', Icons.bug_report),
                    _buildServiceButton('Anal Gland Expression', Icons.face),
                    _buildServiceButton('Paw Pad Care', Icons.pets),
                  ],
                ),
                SizedBox(height: 30),
                //Text
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Recommended Groomers',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                //Horizontal scroll
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            // Handle the click event here, e.g., navigate to a page
                            // when one of the items is clicked
                            // You can use a switch statement or if-else to determine
                            // which item was clicked based on the 'index' variable.
                            switch (index) {
                              case 0:
                              // Handle the click for the first item
                                break;
                              case 1:
                              // Handle the click for the second item
                                break;
                            // Add cases for the other items as needed
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150, // Set the width of each item
                                margin: EdgeInsets.symmetric(horizontal: 10), // Add horizontal margin
                                decoration: BoxDecoration(
                                  color: Color(0xffD1B3C4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Item ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10), // Space between item and description
                              Text(
                                'Description for Item ${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
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

//Icons
Widget _buildServiceButton(String label, IconData iconData) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        iconData,
        size: 48, // Adjust the icon size as needed
        color: Colors.black, // Adjust the icon color as needed
      ),
      SizedBox(height: 8), // Add spacing between icon and label
      Text(
        label,
        style: TextStyle(
          fontSize: 16, // Adjust the label font size as needed
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}


