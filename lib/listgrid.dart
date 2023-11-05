import 'package:flutter/material.dart';
import 'package:utsprak/detail.dart';
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class ListMovieGrid extends StatefulWidget {
  const ListMovieGrid({super.key});

  @override
  State<ListMovieGrid> createState() => _ListMovieGridState();
}

class _ListMovieGridState extends State<ListMovieGrid> {
  List<Movie> dataMovies = []; // List to store movie data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Fetch movies when the widget is initialized
  }

  void fetchMovies() async {
    try {
      List<Movie> movies = await APIServices
          .getMovie(); // Replace with the method to get movies from the API
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
        backgroundColor: const Color(0xFF4F88F7),
        title: const Text("Now Showing"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                itemCount:
                    dataMovies.where((movie) => movie.kategori == "now").length,
                itemBuilder: (context, index) {
                  final filteredMovies = dataMovies
                      .where((movie) => movie.kategori == "now")
                      .toList();
                  return InkWell(
                    child: Column(
                      children: [
                        Image.network(
                          filteredMovies[index].poster ?? "",
                          width: 150.0,
                          height: 220.0,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                Detail(
                                      id: filteredMovies[index].idMovie ?? ""),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(0xFFA1C5EF);
                                  }
                                  return const Color(0xFF233269);
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
      ),
    );
  }
}
