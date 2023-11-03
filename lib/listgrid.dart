import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utsprak/detail.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart';

class ListMovieGrid extends StatefulWidget {
  
  const ListMovieGrid ({super.key});

  @override
  State<ListMovieGrid> createState() => _ListMovieGridState();
}

class _ListMovieGridState extends State<ListMovieGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: const Text("Now Showing"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Database.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final dataMovies = snapshot.data!.docs
                .map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return movie.fromJson(data);
                })
                .where((movie) =>
                    movie.kategori ==
                    "now") // Filter berdasarkan kategori "now"
                .toList();

            return Container(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                itemCount: dataMovies.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Column(
                      children: [
                        Image.network(
                          dataMovies[index].poster,
                          width: 150.0,
                          height: 220.0,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 10),
                        // Tambahkan tombol di sini jika diperlukan
                        SizedBox(
                          width: 150, // <-- Your width
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Detail(nama: dataMovies[index].nama),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(
                                        0xFFA1C5EF); //warna pas ditekan
                                  }
                                  return const Color(
                                      0xFF233269); //warna default
                                },
                              ),
                              fixedSize:
                                  MaterialStateProperty.all(const Size(0, 0)),
                            ),
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.63,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
              ),
            );
          }
        },
      ),
    );
  }
}

