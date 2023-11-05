import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import Dio
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class RiwayatP extends StatefulWidget {
  const RiwayatP({Key? key}) : super(key: key);

  @override
  _RiwayatPState createState() => _RiwayatPState();
}

class _RiwayatPState extends State<RiwayatP> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<BookingWithMovieInfo> riwayatPemesanan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingDataWithMovieInfo(); // Panggil method untuk mengambil data
  }

  // Method untuk mengambil data booking dengan informasi film
  void fetchBookingDataWithMovieInfo() async {
    try {
      final List<BookingWithMovieInfo> bookings =
          await APIServices.getBookingUser(_auth.currentUser!.email ?? "");

      setState(() {
        riwayatPemesanan = bookings;
        isLoading =
            false; // Set isLoading menjadi false setelah selesai mengambil data
      });
    } catch (error) {
      print('Terjadi kesalahan: $error');
      isLoading = false; // Set isLoading menjadi false jika terjadi kesalahan
      // Handle kesalahan jika diperlukan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: Text('Riwayat Pemesanan'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: riwayatPemesanan.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                        riwayatPemesanan[index].movieInfo.poster ??
                            ""), // Menampilkan gambar dengan Image.network
                    title:
                        Text('Film: ${riwayatPemesanan[index].movieInfo.name}'),
                    subtitle: Text(
                        'Jam: ${riwayatPemesanan[index].booking.jam}, Kursi: ${riwayatPemesanan[index].booking.kursi}'),
                  ),
                );
              },
            ),
    );
  }
}
