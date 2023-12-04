import 'package:flutter/material.dart';
import 'package:groomify/functions/firestore_controller.dart';
import 'package:groomify/pages/appointment.dart';
import 'package:groomify/pages/btmNavBar.dart';
import 'package:groomify/pages/groomers.dart';
import 'package:groomify/pages/home.dart';
import 'package:groomify/pages/profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GroomerDetails extends StatefulWidget {
  final String email;

  const GroomerDetails({required this.email, Key? key}) : super(key: key);

  @override
  State<GroomerDetails> createState() => _GroomerDetailsState();
}

class _GroomerDetailsState extends State<GroomerDetails> {
  final firestoreController = FirestoreController();
  int _selectedIndex = 1;
  String? email;
  String? fullName;
  String? username;
  String? salon;
  String? location;
  String? profilePictureURL;
  String? contact;
  Map<String, TimeOfDay?> operatingHours = {};
  double minPrice = 0.0;
  double maxPrice = 100.0;
  List<String> services = [];
  double rating = 0.0;

  String? errorMessage;
  bool showBookNowButton = true;

  @override
  void initState() {
    super.initState();
    _fetchGroomerData();
  }

  Future<void> _fetchGroomerData() async {
    final groomerData =
        await firestoreController.getGroomerDataByEmail(widget.email);
    if (groomerData != null) {
      setState(() {
        fullName = groomerData['fullName'];
        username = groomerData['username'];
        salon = groomerData['salonName'];
        location = groomerData['location'];
        profilePictureURL = groomerData['profile_picture'];
        email = groomerData['email'];
        final dynamic ratingData = groomerData['rating'];
        rating = ratingData is double ? ratingData : 0.0;
        contact = groomerData['contactNo'];

        Map<String, TimeOfDay?> operatingHoursData = {
          'openingTime': groomerData['opening_time'] != null
              ? TimeOfDay(
                  hour: groomerData['opening_time']['hour'],
                  minute: groomerData['opening_time']['minute'],
                )
              : null,
          'closingTime': groomerData['closing_time'] != null
              ? TimeOfDay(
                  hour: groomerData['closing_time']['hour'],
                  minute: groomerData['closing_time']['minute'],
                )
              : null,
        };
        operatingHours = operatingHoursData;

        if (groomerData['services'] != null) {
          services = List<String>.from(groomerData['services']);
        }

        final priceRange = groomerData['price_range'];
        if (priceRange != null) {
          minPrice = priceRange['min_price'] ?? minPrice;
          maxPrice = priceRange['max_price'] ?? maxPrice;
        }

        // Check if contact is null or empty
        if (contact == null || contact!.isEmpty) {
          errorMessage = 'Not Available';
          showBookNowButton = false;
        } else {
          errorMessage = null;
          showBookNowButton = true;
        }
      });
    }
  }

  void refreshPage() {
    _fetchGroomerData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
    if (index == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const GroomerPage()));
    }
    if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    const int rowCount = 3;
    const int colCount = 3;

    final List<TableCell> serviceCells = List.generate(
      rowCount * colCount,
      (index) {
        if (index < services.length) {
          return TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                services[index],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        } else {
          return TableCell(
            child: Container(),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
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
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff735D78)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 90,
                backgroundImage: profilePictureURL != null
                    ? NetworkImage(profilePictureURL!)
                    : const NetworkImage(
                        'https://static.vecteezy.com/system/resources/thumbnails/002/534/006/small/social-media-chatting-online-blank-profile-picture-head-and-body-icon-people-standing-icon-grey-background-free-vector.jpg',
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        salon ?? 'Loading...',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Rating: ',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        RatingBar.builder(
                          initialRating: rating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (newRating) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Location: ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      location ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Operating Hours: ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    operatingHours['openingTime'] != null &&
                            operatingHours['closingTime'] != null
                        ? Text(
                            '${formatTimeOfDay(operatingHours['openingTime']!)} - ${formatTimeOfDay(operatingHours['closingTime']!)}',
                            style: const TextStyle(fontSize: 20),
                          )
                        : const Text(
                            'Not Available',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                    const SizedBox(height: 15),
                    const Text(
                      'Full Name: ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      fullName ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Username: ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      username ?? 'Loading...',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Contact Number: ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    errorMessage != null
                        ? Text(
                            errorMessage!,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.red),
                          )
                        : formatContactNumber(contact),
                    const SizedBox(height: 15),
                    const Text(
                      'Price Range (RM): ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$minPrice - $maxPrice',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Services: ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: List.generate(
                        rowCount,
                        (rowIndex) {
                          return TableRow(
                            children: serviceCells
                                .sublist(
                                  rowIndex * colCount,
                                  (rowIndex + 1) * colCount,
                                )
                                .map((cell) => TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: cell.child,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: w * 0.36,
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
                    onPressed: showBookNowButton
                        ? () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AppointmentPage(
                                    groomerServices: services,
                                    salon: salon!,
                                    email: email!,
                                    contact: contact!,
                                  );
                                },
                              ),
                            );
                          }
                        : null,
                    child: const Text('Book Now'),
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

Widget formatContactNumber(String? phoneNumber) {
  if (phoneNumber != null && phoneNumber.isNotEmpty) {
    final formattedNumber = phoneNumber.replaceRange(3, 3, '-');
    return Text(
      formattedNumber,
      style: const TextStyle(fontSize: 20),
    );
  } else {
    return const Text(
      'Not Available',
      style: TextStyle(fontSize: 20, color: Colors.red),
    );
  }
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  int hour = timeOfDay.hour;
  int minute = timeOfDay.minute;
  String period = 'AM';

  if (hour >= 12) {
    period = 'PM';
    if (hour > 12) {
      hour -= 12;
    }
  }

  final hourStr = hour.toString();
  final minuteStr = minute.toString().padLeft(2, '0');

  return '$hourStr:$minuteStr $period';
}
