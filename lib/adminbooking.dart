import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart';

class DataBooking extends StatefulWidget {
  const DataBooking({Key? key}) : super(key: key);

  @override
  _DataBookingState createState() => _DataBookingState();
}

class _DataBookingState extends State<DataBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Booking"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Database.getBookingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final bookingData = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Booking.fromJson(data);
            }).toList();

            return ListView.builder(
              itemCount: bookingData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      "Email: ${bookingData[index].email} || Judul: ${bookingData[index].film}"),
                  subtitle: Text(
                      "Jam: ${bookingData[index].jam} - Kursi: ${bookingData[index].kursi}"),
                );
              },
            );
          } else {
            return Text("Tidak ada data booking.");
          }
        },
      ),
    );
  }
}
