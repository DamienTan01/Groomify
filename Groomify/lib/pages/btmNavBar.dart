// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:groomify/pages/home.dart';
//
// class CustomNavBar extends StatelessWidget {
//   final List<Widget> _pages = [HomePage(email: email)];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         final currentIndex = Get.find<BottomNavController>().currentIndex;
//         return _pages[currentIndex];
//       }),
//       bottomNavigationBar: Obx(() {
//         final currentIndex = Get.find<BottomNavController>().currentIndex;
//         return BottomNavigationBar(
//           currentIndex: currentIndex,
//           onTap: (index) {
//             Get.find<BottomNavController>().changePage(index);
//           },
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: 'Settings',
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
