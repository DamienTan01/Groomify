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
      body: Column(
        children: [
          SizedBox(height: 20),
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
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIconColor: Color(0xff735D78),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for Groomers',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          //Text
          Column(
            children: [
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
              SizedBox(height: 20),
              //Services
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.pets_outlined),
                        onPressed: () {
                          // Add your onPressed logic here
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
