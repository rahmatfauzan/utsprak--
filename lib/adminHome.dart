import 'package:flutter/material.dart';
import 'package:utsprak/AdminTambahMovie.dart';
import 'package:utsprak/model/api_model.dart';
import 'package:utsprak/model/api_service.dart';

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Movie> dataMovies = [];

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
      });
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Data movie"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final shouldRefresh = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => AddMovie(),
                ),
              );
              if (shouldRefresh == true) {
                fetchMovies();
              }
            },
          ),
        ],
      ),
      body: dataMovies.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
              ),
            )
          : ListView.builder(
              itemCount: dataMovies.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(dataMovies[index].idMovie ?? ""),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                    try {
                      // Menghapus film dengan menggunakan metode deleteMovie
                      await APIServices.deleteMovie(dataMovies[index].idMovie);
                      print('Movie deleted successfully.');
                    } catch (e) {
                      print('Error: $e');
                    }
                  },

                  child: InkWell(
                    // Navigasi ke halaman AddMovie untuk mengedit data film
                    onTap: () async {
                      final shouldRefresh =
                          await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMovie(movieToEdit: dataMovies[index]),
                        ),
                      );
                      if (shouldRefresh == true) {
                        fetchMovies();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            imageWidget(dataMovies[index].poster ?? ""),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataMovies[index].name ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    dataMovies[index].genre ?? "",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 255, 191, 0),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    dataMovies[index].desc ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${dataMovies[index].durasi} m" ?? "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            dataMovies[index].kategori == "soon"
                                                ? Colors.red
                                                : Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        dataMovies[index].kategori == "soon"
                                            ? "soon"
                                            : "now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget imageWidget(String imageUrl) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
