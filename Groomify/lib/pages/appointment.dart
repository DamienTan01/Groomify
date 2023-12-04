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
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String? email;
  String? fullName;
  String? contact;
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

  Future<void> _fetchUserData() async {
    final user = AuthController.instance.auth.currentUser;
    if (user != null) {
      final userData =
      await firestoreController.getUserDataByEmail(user.email!);
      if (userData != null) {
        setState(() {
          email = userData['email'];
          fullName = userData['fullName'];
          contact = userData['contactNo'];
        });
      }
    }
  }

  void _selectDate(DateTime date) {
    final now = DateTime.now();

    if (date.isBefore(now) && !isSameDay(date, now)) {
      showSnackBar('Please select a valid date.');
    } else {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void selectTime() async {
    final now = DateTime.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final selectedDateTime = DateTime(
        _selectedDate?.year ?? now.year,
        _selectedDate?.month ?? now.month,
        _selectedDate?.day ?? now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (selectedDateTime.isBefore(now)) {
        showSnackBar('Please select a valid time.');
      } else {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmAppointment(BuildContext context) async {
    if (_selectedDate == null || _selectedTime == null) {
      showSnackBar('Please select both date and time.');
    } else {
      final selectedServices = list
          .where((checkbox) => checkbox.isSelected)
          .map((checkbox) => checkbox.title)
          .toList();

      if (selectedServices.isEmpty) {
        showSnackBar('Please select at least one service.');
      } else {
        // Save the new booking information
        await firestoreController.uploadAppointmentInfo(
          context,
          widget.salon,
          widget.email,
          _selectedDate!,
          _selectedTime!,
          selectedServices,
        );

        // Appointment Data for User
        final appointmentDataUser = {
          'email': widget.email,
          'salonName': widget.salon,
          'selectedDate': _selectedDate!.toUtc(),
          'selectedTime': _selectedTime!.format(context),
          'selectedServices': selectedServices,
        };

        // Call the function to add the booking to the booking history
        await firestoreController.addAppointmentToUser(email!, appointmentDataUser);

        // Appointment Data for Groomer
        final appointmentDataGroomer = {
          'fullName': fullName,
          'email': email,
          'selectedDate': _selectedDate!.toUtc(),
          'selectedTime': _selectedTime!.format(context),
          'selectedServices': selectedServices,
          'contactNo': contact,
        };
        await firestoreController.addAppointmentToGroomer(widget.email, appointmentDataGroomer);

        // Show a success message using a Snackbar
        showSnackBar('Appointment confirmed!');

        // Navigate to the new HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
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
              onDateSelected: _selectDate, // Call the selectDate function when a date is selected
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
                  onDaySelected: (date, focusedDay) {
                    _selectDate(date); // Call the selectDate function when a date is selected
                  },
                ),
                const SizedBox(height: 30),
                // Display selected time in one box
                TimeBox(
                  title: 'Selected Time',
                  time: _selectedTime,
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
                    onPressed: selectTime, // Show time picker when the button is pressed
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
  final void Function(DateTime date)? onDateSelected; // Define the onDateSelected parameter

  const DateBox({Key? key, required this.title, required this.date, this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap the DateBox with a GestureDetector
      onTap: () {
        if (onDateSelected != null) {
          onDateSelected!(date ?? DateTime.now()); // Call the onDateSelected function when tapped
        }
      },
      child: Container(
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
              date != null
                  ? DateFormat('MMMM d, yyyy').format(date!)
                  : 'Not selected',
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
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
