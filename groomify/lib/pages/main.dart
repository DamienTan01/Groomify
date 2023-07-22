import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //ensure Firebase initialised before app run
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groomify',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF731942),
          selectedItemColor: Color(0xFFFFCDD2),
          unselectedItemColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF731942)),
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => HomePage(
          comicList: [],
          novelList: [],
        ),
        UserProfile.routeName: (context) => UserProfile(),
        BookmarkPage.routeName: (context) => BookmarkPage(),
        ComicBookmarkPage.routeName: (context) => ComicBookmarkPage(),
        NovelBookmarkPage.routeName: (context) => NovelBookmarkPage(),
        ComicPage.routeName: (context) => ComicPage(),
        ComicListPage.routeName: (context) => ComicListPage(),
        ComicDetailPage.routeName: (context) => ComicDetailPage(
          refreshUI: refresh,
        ),
        NovelPage.routeName: (context) => NovelPage(),
        NovelListPage.routeName: (context) => NovelListPage(),
        NovelDetailPage.routeName: (context) => NovelDetailPage(
          refreshUI: refresh,
        ),
      },
    );
  }
}
