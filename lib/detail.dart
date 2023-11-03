import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utsprak/detail_jam.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart'; // Import your data model

class Detail extends StatelessWidget {
  final String nama;

  Detail({Key? key, required this.nama}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<movie>(
      future: Database.getMovie(
          nama: nama), // Fetch movie data based on the provided 'nama'
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
          // Display a loading indicator while fetching data.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final dataMovie = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF4F88F7),
              title: Text(
                  dataMovie.nama), // Display the movie name from the database
            ),
            resizeToAvoidBottomInset: false, // set it to false
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(dataMovie.banner,
                        width: 500.0, fit: BoxFit.fill),
                    const SizedBox(height: 10),
                    Text(
                      dataMovie.nama, // Display the movie name
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.book),
                            Text(dataMovie.genre), // Display the movie genre
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.access_time_outlined),
                            Text(
                                "${dataMovie.durasi} minutes"), // Display the movie duration
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dataMovie.desc, // Display the movie description
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (dataMovie.kategori != "soon") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TimeSelectionPage(nama: nama),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return dataMovie.kategori == "soon"
                                  ? Color.fromARGB(255, 207, 20,
                                      20) // Warna merah saat ditekan dan kategori "soon"
                                  : const Color(
                                      0xFFA1C5EF); // Warna saat ditekan dan kategori bukan "soon"
                            }
                            return dataMovie.kategori == "soon"
                                ? Color.fromARGB(255, 212, 21,
                                    21) // Warna merah saat kategori "soon"
                                : const Color(
                                    0xFF233269); // Warna default saat kategori bukan "soon"
                          },
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(300, 50)),
                      ),
                      child: Text(
                        dataMovie.kategori == "soon"
                            ? 'Soon'
                            : 'Buy Now', // Ganti teks sesuai dengan kategori
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        } else {
          return Text(
              'Movie not found'); // Handle the case where the movie is not found in the database.
        }
      },
    );
  }
}
