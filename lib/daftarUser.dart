import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance; // Use the prefix
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noTlpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: noTlpController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final myUser = MyUser(
                  // Use the User model from your local code
                  nama: namaController.text,
                  email: _auth.currentUser?.email ?? "", // User's email address
                  noTlp: noTlpController.text,
                  alamat: alamatController.text,
                  kategori: "user",
                );

                await APIServices.addUser(
                    myUser); // Use the addUser method from APIServices

                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Simpan Pengguna'),
            ),
          ],
        ),
      ),
    );
  }
}
