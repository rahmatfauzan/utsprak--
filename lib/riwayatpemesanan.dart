import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart'; // Sesuaikan dengan lokasi berkas database Anda

class RiwayatP extends StatefulWidget {
  const RiwayatP({super.key});

  @override
  _RiwayatPState createState() => _RiwayatPState();
}

class _RiwayatPState extends State<RiwayatP> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Booking> riwayatPemesanan = []; // Menyimpan data pemesanan

  @override
  void initState() {
    super.initState();
    // Mengambil data pemesanan dari Firestore
    Database.getBookingsByEmail(email: _auth.currentUser!.email ?? "")
        .then((bookings) {
      setState(() {
        riwayatPemesanan = bookings;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF4F88F7),
          title: Text('Riwayat Pemesanan'),
        ),
        body: ListView.builder(
          padding: EdgeInsets.only(top: 5),
          itemCount: riwayatPemesanan.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text('Film: ${riwayatPemesanan[index].film}'),
                subtitle: Text(
                    'Jam: ${riwayatPemesanan[index].jam}, Kursi:${riwayatPemesanan[index].kursi}'),
                // Tambahkan informasi lain yang ingin ditampilkan di sini
              ),
            );
          },
        ));
  }
}
