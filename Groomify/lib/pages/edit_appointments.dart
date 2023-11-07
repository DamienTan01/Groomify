import 'package:flutter/material.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';
import 'package:intl/intl.dart';

class EditAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const EditAppointmentPage({Key? key, required this.appointmentData})
      : super(key: key);

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {

  int _selectedIndex = 0;

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
    // Access the appointment data from the widget


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Appointment',
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
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff735D78)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

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
