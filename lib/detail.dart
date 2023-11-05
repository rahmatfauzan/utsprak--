import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utsprak/detail_jam.dart';
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class Detail extends StatefulWidget {
  final String id;

  Detail({Key? key, required this.id}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Movie dataMovie = Movie(); // Initialize dataMovie as an empty Movie object
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      Movie movie = await APIServices.getMovieById(widget.id);
      setState(() {
        dataMovie = movie;
        isLoading = false; // Set isLoading to false after data is fetched
      });
    } catch (e) {
      print("Error fetching movie: $e");
      isLoading = false; // Set isLoading to false in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F88F7),
        title: Text(dataMovie.name ?? ''), // Display the movie name
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(dataMovie.banner ?? '',
                        width: 500.0, fit: BoxFit.fill),
                    const SizedBox(height: 10),
                    Text(
                      dataMovie.name ?? '', // Display the movie name
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
                            Text(dataMovie.genre ??
                                ''), // Display the movie genre
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
                      dataMovie.desc ?? '', // Display the movie description
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
                                  TimeSelectionPage(
                                  id: dataMovie.idMovie ?? ''),
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
                                  ? Color.fromARGB(255, 207, 20, 20)
                                  : const Color(0xFFA1C5EF);
                            }
                            return dataMovie.kategori == "soon"
                                ? Color.fromARGB(255, 212, 21, 21)
                                : const Color(0xFF233269);
                          },
                        ),
                        fixedSize:
                            MaterialStateProperty.all(const Size(300, 50)),
                      ),
                      child: Text(
                        dataMovie.kategori == "soon" ? 'Soon' : 'Buy Now',
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
  }
}
