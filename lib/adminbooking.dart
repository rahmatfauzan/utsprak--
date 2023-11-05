import 'package:flutter/material.dart';
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class DataBooking extends StatefulWidget {
  const DataBooking({Key? key}) : super(key: key);

  @override
  _DataBookingState createState() => _DataBookingState();
}

class _DataBookingState extends State<DataBooking> {
  List<BookingWithMovieInfo> riwayatPemesanan = [];
  bool isLoading = true; // Tambahkan status loading

  @override
  void initState() {
    super.initState();
    fetchBookingDataWithMovieInfo();
  }

  void fetchBookingDataWithMovieInfo() async {
    try {
      final List<BookingWithMovieInfo> bookings =
          await APIServices.getBookingDataWithMovieInfo();

      setState(() {
        riwayatPemesanan = bookings;
        isLoading = false; // Setelah data diambil, berhenti loading
      });
    } catch (error) {
      print('Terjadi kesalahan: $error');
      isLoading = false; // Set loading ke false jika terjadi kesalahan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: Text('Data Booking'),
      ),
      body: isLoading // Periksa status loading
          ? Center(
              child:
                  CircularProgressIndicator(), // Tampilkan circular progress jika sedang loading
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: riwayatPemesanan.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          riwayatPemesanan[index].movieInfo.poster ?? ""),
                    ),
                    title: Text(
                      'Email: ${riwayatPemesanan[index].booking.email} || Film: ${riwayatPemesanan[index].movieInfo.name}',
                    ),
                    subtitle: Text(
                      'Jam: ${riwayatPemesanan[index].booking.jam}, Kursi: ${riwayatPemesanan[index].booking.kursi}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
