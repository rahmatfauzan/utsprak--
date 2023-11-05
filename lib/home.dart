import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utsprak/detail.dart';
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> dataMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      List<Movie> movies = await APIServices.getMovie();
      setState(() {
        dataMovies = movies;
        isLoading =
            false; // Set isLoading menjadi false setelah selesai mengambil data
      });
    } catch (e) {
      print("Error fetching movies: $e");
      isLoading = false; // Set isLoading menjadi false jika terjadi kesalahan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //ngilangin appbar
        elevation: 0,
        toolbarHeight: 0,
        //ngubah warna status bar
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF4F88F7),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo",
                    style: TextStyle(
                        color: Color(0xFF393434),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        fontSize: 28),
                  ),
                  const Text(
                    "Mau nonton apa hari ini?",
                    style: TextStyle(
                        color: Color(0xFF393434),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        fontSize: 16),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dataMovies.length,
                      itemBuilder: (context, index) {
                        if (dataMovies[index].kategori == "soon") {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(
                                      id: dataMovies[index].idMovie ?? ""),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.network(
                                  dataMovies[index].poster ?? "",
                                  width: 320.0,
                                  height: 200.0,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          );
                        } else {
                          // Jika kategori bukan "soon", return widget kosong atau null.
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Now Showing",
                        style: TextStyle(
                            color: Color(0xFF393434),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dataMovies.length,
                      itemBuilder: (context, index) {
                        if (dataMovies[index].kategori == "now") {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Detail(
                                      id: dataMovies[index].idMovie ?? ""),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.network(
                                  dataMovies[index].poster ?? "",
                                  width: 150.0,
                                  height: 220.0,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          );
                        } else {
                          // Jika kategori bukan "soon", return widget kosong atau null.
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
