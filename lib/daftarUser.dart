import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utsprak/home.dart';
import 'package:utsprak/main.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
                  // Menggunakan nama kelas MyUser yang telah diganti
                  nama: namaController.text,
                  email:
                      _auth.currentUser?.email ?? "", // Alamat email pengguna
                  noTlp: noTlpController.text,
                  alamat: alamatController.text,
                  kategori: "user",
                );

                await Database.tambahUser(user: myUser); // Menggunakan MyUser

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
