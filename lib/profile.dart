import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utsprak/login.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final email = user.email;
      if (email != null) {
        final myUser = await Database.getUser(email: email);
        if (myUser != null) {
          setState(() {
            _currentUser = myUser;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            if (_currentUser != null)
              CircleAvatar(
                radius: 70,
                backgroundImage:
                    AssetImage('assets/image/user.jpg'), // Pastikan ini benar
              ),
            const SizedBox(height: 20),

            if (_currentUser == null)
              Center(
                child: Container(
                  width: 60.0, // Lebar container
                  height: 60.0, // Tinggi container
                  decoration: BoxDecoration(
                    shape: BoxShape
                        .circle, // Mengatur bentuk container menjadi lingkaran
                    color: Colors.white, // Warna latar belakang container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, // Warna bayangan
                        blurRadius: 6.0, // Radius bayangan
                        spreadRadius: 1.0, // Sebaran bayangan
                      ),
                    ],
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
              )
            else
              Column(
                children: [
                  ProfileInfo("Name", _currentUser?.nama ?? ""),
                  const SizedBox(height: 20),
                  ProfileInfo("Phone", _currentUser?.noTlp ?? ""),
                  const SizedBox(height: 20),
                  ProfileInfo("Email", _currentUser?.email ?? ""),
                ],
              ),

            const SizedBox(height: 20),

            if (_currentUser != null)
              ElevatedButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: Text('Log Out'),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String value;

  ProfileInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      height: 80,
      width: 800,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.deepPurple.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: 12,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
