import 'package:flutter/material.dart';
import 'package:groomify/functions/auth_controller.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/groomer_profile.dart';
import 'package:groomify/pages/groomer_btmNavBar.dart';
import 'package:intl/intl.dart';

class GroomerHome extends StatefulWidget {
  const GroomerHome({super.key});

  @override
  State<GroomerHome> createState() => _GroomerHomeState();
}

class _GroomerHomeState extends State<GroomerHome> {
  final firestoreController = FirestoreController();

  int _selectedIndex = 0;
  String? email;
  String? profilePictureURL;
  String? salon;
  String? location;
  List<String> groomerEmails = [];
  List<Map<String, dynamic>> appointmentData = [];

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

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() async {
    final user = AuthController.instance.auth.currentUser;
    final email = user!.email;
    if (email != null) {
      final appointments = await firestoreController.getAppointmentsGroomer(email);
      setState(() {
        appointmentData = appointments;
      });
    }
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
      body: SingleChildScrollView (
        child: Column(
          children: [
            const SizedBox(height: 20),
            //Text
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
              child: appointmentData.isEmpty
                  ? const Center(
                child: Text(
                  "No Appointments Made",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
                  : ListView.builder(
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
                          '${appointment['fullName']}',
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
                      ],
                    ),
                  );
                },
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
