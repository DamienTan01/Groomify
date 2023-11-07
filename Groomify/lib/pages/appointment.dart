import 'package:flutter/material.dart';
import 'package:groomify/functions/auth_controller.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final List<String> groomerServices;
  final String salon;
  final String email;

  const AppointmentPage({
    Key? key,
    required this.groomerServices,
    required this.salon, // Pass the groomer's services as a parameter
    required this.email,
  }) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPage();
}

class _AppointmentPage extends State<AppointmentPage> {
  final firestoreController = FirestoreController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? email;
  int _selectedIndex = 1;
  List<String> selectedServices = [];
  List<CheckboxListTileModel> list = [];
  List<String> appointments = [];

  void _initServicesList() {
    for (final service in widget.groomerServices) {
      list.add(CheckboxListTileModel(
        title: service,
        isSelected: false,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _initServicesList();
  }

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

  void _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  Future<void> _fetchUserData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      final userData =
      await firestoreController.getUserDataByEmail(user.email!);
      if (userData != null) {
        setState(() {
          email = userData['email'];
        });
      }
    }
  }

  void _confirmAppointment(BuildContext context) async {
    if (email != null && _selectedDate != null && _selectedTime != null) {
      final selectedServices = list
          .where((checkbox) => checkbox.isSelected)
          .map((checkbox) => checkbox.title)
          .toList();

      // Save the new booking information
      await firestoreController.uploadAppointmentInfo(
        context,
        widget.salon,
        widget.email,
        _selectedDate!,
        _selectedTime!,
        selectedServices,
      );

      // Create a map with the booking information
      final appointmentData = {
        'email': widget.email,
        'salonName': widget.salon,
        'selectedDate': _selectedDate!.toUtc(),
        'selectedTime': _selectedTime!.format(context),
        'selectedServices': selectedServices,
      };

      // Call the function to add the booking to the booking history
      await firestoreController.addAppointmentToUser(email!, appointmentData);


      // Show a success message using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment confirmed!'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );

      // Navigate back to the GroomerDetails
      Navigator.pop(context);
    } else {
      // Handle the case when some required data is missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date, time, and services.'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking',
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
            const SizedBox(height: 20),
            DateBox(
              title: 'Selected Date',
              date: _selectedDate,
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2023, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDate, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDate;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
                const SizedBox(height: 30),
                // Display selected time in one box
                GestureDetector(
                  onTap: _selectTime,
                  child: TimeBox(
                    title: 'Selected Time',
                    time: _selectedTime,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: w * 0.37,
                  height: h * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color(0xff735D78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _selectTime, // Show time picker when the button is pressed
                    child: const Text('Select Time'), // Display only "Select Time" in the button
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Services
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Services',
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
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: w * 0.3,
                  height: h * 0.06,
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
                      _confirmAppointment(context);

                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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

// Box to display selected time
class TimeBox extends StatelessWidget {
  final String title;
  final TimeOfDay? time;

  const TimeBox({Key? key, required this.title, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff735D78)),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            time != null ? time!.format(context) : 'Not selected',
            style: const TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final String title;
  final DateTime? date;

  const DateBox({Key? key, required this.title, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff735D78)),
        borderRadius: BorderRadius.circular(10), // Fix the typo here
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date != null
                ? DateFormat('MMMM d, yyyy').format(date!)
                : 'Not selected',
            style: const TextStyle(fontSize: 22),
          ),
        ],
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
