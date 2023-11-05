import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utsprak/adminHome.dart';
import 'package:utsprak/adminbooking.dart';
import 'package:utsprak/home.dart';
import 'package:utsprak/listgrid.dart';
import 'package:utsprak/login.dart';
import 'package:utsprak/profile.dart';
import 'package:utsprak/riwayatpemesanan.dart';
import 'package:utsprak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Tentukan rute awal
      routes: {
        '/login': (context) => Login(), // Halaman login
        '/home': (context) => MyBottomNavBar(), // Halaman home
        '/admin': (context) => ButtomAdmin(), // Halaman home
        // Definisikan rute-rute lainnya di sini
      },
    );
  }
}

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const ListMovieGrid(),
    RiwayatP(),
    const Profile(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: const Color(0xFF4F88F7),
          color: const Color(0xFF233269),
          activeColor: const Color(0xFF233269),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          tabBackgroundColor: Colors.white,
          tabMargin: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.movie,
              text: 'movie',
            ),
            GButton(
              icon: Icons.adf_scanner,
              text: 'Tickets',
            ),
            GButton(
              icon: Icons.account_circle,
              text: 'Profile',
            )
          ],
        ));
  }
}

class ButtomAdmin extends StatefulWidget {
  const ButtomAdmin({super.key});

  @override
  State<ButtomAdmin> createState() => _ButtomAdminState();
}

class _ButtomAdminState extends State<ButtomAdmin> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    AdminHome(),
    const DataBooking(),
    AdminHome(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: const Color(0xFF4F88F7),
          color: const Color(0xFF233269),
          activeColor: const Color(0xFF233269),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tabBackgroundColor: Colors.white,
          tabMargin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.movie,
              text: 'Booking',
            ),
            GButton(
              icon: Icons.logout_outlined,
              text: 'Logout',
              onPressed: () {
                _showLogoutConfirmationDialog();
              },
            ),
          ],
));
  }

  void _showLogoutConfirmationDialog() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final BuildContext dialogContext = context; // Simpan context dalam variabel

    showDialog(
      context: dialogContext, // Gunakan dialogContext
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Apakah Anda yakin ingin logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                  dialogContext, // Gunakan dialogContext
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: Text("Ya, Logout"),
            ),
          ],
        );
      },
    );
  }
}



