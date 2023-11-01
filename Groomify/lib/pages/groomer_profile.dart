import 'package:flutter/material.dart';
import 'package:groomify/pages/groomer_btmNavBar.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';
import 'package:groomify/pages/groomer_home.dart';

class GroomerProfile extends StatefulWidget {
  const GroomerProfile({super.key});

  @override
  State<GroomerProfile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<GroomerProfile> {
  TextEditingController salonController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  int _selectedIndex = 1;
  bool showPassword = false;
  bool isEditingSalon = false;
  bool isEditingLocation = false;
  String? fullName;
  String? username;
  String? email;
  String? password;
  String? role;
  String? salon;
  String? tempSalon;
  String? location;
  String? tempLocation;
  String? profilePictureURL;
  double priceStart = 0.0;
  double priceEnd = 100.0;
  List<String> selectedServices = [];

  final firestoreController = FirestoreController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const GroomerHome()));
    }
    if (index == 1) {
      // Navigate to the Profile page
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const GroomerProfile()));
    }
  }

  // Fetch user data from Firestore when the widget is initialized
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

          // Update selectedServices based on Firestore data
          selectedServices = List<String>.from(userData['services']);

          // Set the initial checkbox states based on selectedServices
          for (var checkbox in list) {
            checkbox.isSelected = selectedServices.contains(checkbox.title);
          }
        });
      }
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

  // Create a list of items with their respective states (checked or unchecked).
  List<CheckboxListTileModel> list = <CheckboxListTileModel>[
    CheckboxListTileModel(
      title: 'Pet Bathing',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Haircuts',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Nail Trim',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Teeth Clean',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Ear Clean',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Flea & Tick Treatment',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Anal Gland Expression',
      isSelected: false,
    ),
    CheckboxListTileModel(
      title: 'Paw Pad Care',
      isSelected: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: profilePictureURL != null
                      ? NetworkImage(profilePictureURL!)
                      : const NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                        ),
                ),
                Positioned(
                  bottom: -10,
                  left: 120,
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      firestoreController.uploadGroomerProfilePicture(email!);
                    },
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const SizedBox(height: 50),
            //User Data
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Name:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      fullName ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      username ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                //Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                //Role
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Role:',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      role ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Salon Name
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Salon Name:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isEditingSalon)
                            Text(
                              isEditingSalon ? salonController.text : (salon ?? 'Loading...'), // Use the controller text if editing, or the existing salon name
                              style: const TextStyle(fontSize: 20),
                            )
                          else
                            Expanded(
                              child: TextFormField(
                                controller: salonController,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter Name',
                                ),
                              ),
                            ),
                          IconButton(
                            icon: Icon(isEditingSalon ? Icons.check : Icons.edit),
                            onPressed: () {
                              // Toggle editing mode
                              setState(() {
                                if (isEditingSalon) {
                                  // Save the edited salon and exit editing mode
                                  salon = salonController.text;
                                } else {
                                  // Store the existing salon value in tempSalon
                                  tempSalon = salon;
                                }
                                isEditingSalon = !isEditingSalon;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Location
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Location:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isEditingLocation)
                            Text(
                              location ?? 'Loading...',
                              style: const TextStyle(fontSize: 20),
                            )
                          else
                            Expanded(
                              child: TextFormField(
                                controller: locationController,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter Name',
                                ),
                              ),
                            ),
                          IconButton(
                            icon: Icon(isEditingLocation ? Icons.check : Icons.edit),
                            onPressed: () {
                              // Toggle editing mode
                              setState(() {
                                if (isEditingLocation) {
                                  // Save the edited location and exit editing mode
                                  location = locationController.text;  // Update 'location'
                                } else {
                                  // Store the existing location value in tempLocation
                                  tempLocation = location;  // Update 'tempLocation'
                                }
                                isEditingLocation = !isEditingLocation;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //Services
            Column(
              children: [
                const Text(
                  'Services:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CheckboxListTile(
                            title: Text(list[index].title),
                            value: list[index].isSelected,
                            onChanged: (value) {
                              setState(() {
                                list[index].isSelected = value!;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            // Price Range Slider
            SizedBox(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Price Range:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  RangeSlider(
                    values: RangeValues(priceStart, priceEnd),
                    min: 0,
                    max: 100, // You can adjust min and max values according to your needs
                    divisions: 10, // Optional: Divisions for the slider
                    onChanged: (newRange) {
                      setState(() {
                        priceStart = newRange.start;
                        priceEnd = newRange.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM ${priceStart.toStringAsFixed(2)}', // Display the start price with 2 decimal points
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        'RM ${priceEnd.toStringAsFixed(2)}', // Display the end price with 2 decimal points
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            //Update Button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(
                    right: 20), // Adjust the margin as needed
                child: SizedBox(
                  width: w * 0.3,
                  height: h * 0.05,
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
                      // Update the 'salon' field in Firestore
                      await firestoreController.updateGroomingSalon(salon!, email!);

                      // Update the 'location' field in Firestore
                      await firestoreController.updateSalonLocation(location!, email!);

                      // Update the 'services' field in Firestore
                      await firestoreController.updateServices(list, email!);

                      // Refresh the page after updating
                      refreshPage();
                    },
                    child: const Text('Update'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: GroomerNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class CheckboxListTileModel {
  String title;
  bool isSelected;

  CheckboxListTileModel({
    required this.title,
    required this.isSelected,
  });
}
