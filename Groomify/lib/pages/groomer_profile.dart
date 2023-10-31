import 'package:flutter/material.dart';
import 'package:groomify/controller/provider.dart';
import 'package:groomify/pages/groomer_btmNavBar.dart';
import 'package:groomify/controller/auth_controller.dart';
import 'package:groomify/controller/firestore_controller.dart';
import 'package:groomify/pages/groomer_home.dart';
import 'package:provider/provider.dart';

class GroomerProfile extends StatefulWidget {
  const GroomerProfile({super.key});

  @override
  State<GroomerProfile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<GroomerProfile> {
  int _selectedIndex = 1;
  bool showPassword = false;
  String? fullName;
  String? username;
  String? email;
  String? password;
  String? role;
  String? profilePictureURL;
  List<bool> selectedServices = [];
  late SelectedServicesProvider selectedServicesProvider;

  final firestoreController = FirestoreController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to the Home page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroomerHome()));
    }
    if (index == 1) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroomerProfile()));
    }
  }

  // Fetch user data from Firestore when the widget is initialized
  @override
  void initState() {
    super.initState();
    _fetchGroomerData();
    _fetchProfilePicture();
    _fetchSelectedServices();

    // Initialize selectedServices based on the data from Firestore
    selectedServices = List.generate(list.length, (index) => false);
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
          profilePictureURL = userData['profile_picture'];
        });
      }
    }
  }

  Future<void> _fetchProfilePicture() async {
    final profilePictureURL = await firestoreController.getProfilePictureURL(email!);
    if (profilePictureURL != null) {
      setState(() {
        this.profilePictureURL = profilePictureURL;
      });
    }
  }

  Future<void> _fetchSelectedServices() async {
    // Fetch selected services from Firestore
    final selectedServicesFromFirestore = await firestoreController.getSelectedServices(email!);

    // Initialize selectedServices list with all false values
    selectedServices = List.generate(list.length, (index) => false);

    // Update the selectedServices list based on the data from Firestore
    if (selectedServicesFromFirestore != null) {
      for (int index = 0; index < list.length; index++) {
        final serviceTitle = list[index].title;
        // Check if the service is in the selectedServicesFromFirestore and set the corresponding index to true
        if (selectedServicesFromFirestore.contains(serviceTitle)) {
          selectedServices[index] = true;
        }
      }
    }

    // Set the selectedServices list
    setState(() {
      selectedServices = selectedServices;
    });
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
    // Use the provider to access selected service states
    final selectedServicesProvider = Provider.of<SelectedServicesProvider>(context);

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
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      role ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
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
                // Add padding here
                Padding(
                  padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(list[index].title),
                        value: selectedServicesProvider.selectedServiceStates[index],
                        onChanged: (bool? value) {
                          if (value != null) {
                            selectedServicesProvider.toggleServiceState(index);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 20), // Adjust the margin as needed
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
                      // Create an instance of FirestoreController
                      final firestoreController = FirestoreController();

                      // Create a list of selected service titles based on the selectedServiceStates
                      final selectedServiceTitles = list
                          .where((item) => selectedServicesProvider.selectedServiceStates[list.indexOf(item)])
                          .map((service) => service.title)
                          .toList();

                      // Update the 'services' field in Firestore
                      await firestoreController.updateSelectedServices(email!, selectedServiceTitles);

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