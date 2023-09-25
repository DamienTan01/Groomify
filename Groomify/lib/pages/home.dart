import 'package:flutter/material.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
      body: Stack(
        children: [
          Column(
            children: [
              //Ads
              Container(
                color: Color(0xffB392AC), // Set the background color of the content
                height: 150, // Set the desired height of the content
                child: Center(
                  child: Text(
                    'Content Goes Here',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //Search Bar
          Positioned(
            top: 120, // Adjust the top position to control the overlap
            left: 40, // Adjust the left position to control the overlap
            right: 40, // Adjust the right position to control the overlap
            child: Container(
              height: 50, // Set the height of the search bar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIconColor: Color(0xff735D78),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          //Text
          Positioned(
            top: 200, // Adjust the top position to control the container's position
            left: 20, // Adjust the left position to control the container's position
            child: Container(
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
          ),
          //
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
