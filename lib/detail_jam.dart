import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart';


class TimeSelectionPage extends StatefulWidget {
  TimeSelectionPage({Key? key, required this.nama}) : super(key: key);
  final String nama;

  @override
  _TimeSelectionPageState createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  movie? dataMovie;

  @override
  void initState() {
    super.initState();
    loadMovieData();
  }

  Future<void> loadMovieData() async {
    try {
      movie movieData = await Database.getMovie(nama: widget.nama);
      setState(() {
        dataMovie = movieData;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  final List<String> availableTimes = [
    '10:00 AM',
    '1:00 PM',
    '4:00 PM',
    '7:00 PM',
    '10:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: Text('Pilih Jam Tayang'),
      ),
      body: ListView.builder(
        itemCount: availableTimes.length,
        itemBuilder: (context, index) {
          final time = availableTimes[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                // Action ketika jam tertentu dipilih
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeatSelectionPage(
                        selectedTime: time, movieName: dataMovie!.nama),
                  ),
                );
              },
              title: Text(
                time,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text(dataMovie != null ? dataMovie!.nama : "Loading..."),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}

class SeatSelectionPage extends StatefulWidget {
  final String selectedTime;
  final String movieName;

  SeatSelectionPage({required this.selectedTime, required this.movieName});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> selectedSeats = [];
  List<Booking> bookedSeats = [];
  List<String> availableSeats = [
    'A1',
    'A2',
    'A3',
    'A4',
    'B1',
    'B2',
    'B3',
    'B4',
    'C1',
    'C2',
    'C3',
    'C4',
    'D1',
    'D2',
    'D3',
    'D4',
  ];

  void toggleSeatSelection(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat); // Batalkan pemilihan kursi
      } else {
        selectedSeats.add(seat); // Pilih kursi
      }
    });
  }

  

  @override
  
  void initState() {
    super.initState();
    checkSeatAvailability();
  }

  Future<void> checkSeatAvailability() async {
    final film = widget.movieName;
    final waktu = widget.selectedTime;

    // Panggil method getBookingsByFilmAndWaktu
    final bookings = await Database.getBookingsByFilmAndWaktu(
      film: film,
      waktu: waktu,
    );

    setState(() {
      bookedSeats = bookings;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: Text('Select Seats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tambah teks untuk nama film dan waktu yang dipilih
            Text(
              '${widget.movieName}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Waktu: ${widget.selectedTime}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Daftar kursi dalam 4 baris
            for (int row = 0; row < 4; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int col = 0; col < 4; col++)
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final seat =
                              String.fromCharCode('A'.codeUnitAt(0) + row) +
                                  (col + 1).toString(); // A/B/C/D+nomor kolom
                          if (!bookedSeats
                              .any((booking) => booking.kursi == seat)) {
                            toggleSeatSelection(seat);
                          }
                        },
                        style: selectedSeats.contains(
                                String.fromCharCode('A'.codeUnitAt(0) + row) +
                                    (col + 1).toString())
                            ? ElevatedButton.styleFrom(primary: Colors.green)
                            : bookedSeats.any((booking) =>
                                    booking.kursi ==
                                    String.fromCharCode(
                                            'A'.codeUnitAt(0) + row) +
                                        (col + 1).toString())
                                ? ElevatedButton.styleFrom(primary: Colors.red)
                                : null,
                        child: Text(
                            String.fromCharCode('A'.codeUnitAt(0) + row) +
                                (col + 1).toString()),
                      ),
                    ),
                ],
              ),


            // Tombol "Pesan"
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Konfirmasi Pemesanan'),
                      content:
                          Text('Apakah Anda yakin ingin memesan kursi ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                          },
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Proses pemesanan kursi
                            for (String seat in selectedSeats) {
                              Booking newBooking = Booking(
                                email: _auth.currentUser?.email ??
                                    "", // Gantilah dengan pengguna yang sesuai
                                jam: widget.selectedTime, // Jam film
                                film: widget.movieName, // Nama film
                                kursi: seat, // Nomor kursi
                              );

                              Database.tambahBooking(booking: newBooking);
                            }

                            Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/home');
                          },
                          child: Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Pesan'),
            ),

          ],
        ),
      ),
    );
  }
}

