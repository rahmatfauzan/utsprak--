import 'package:flutter/material.dart';
import 'package:utsprak/model/dataclass.dart';
import 'package:utsprak/model/dbservices.dart';

class AddMovie extends StatefulWidget {
  final movie?
      movieToEdit; // Tambahkan parameter untuk data film yang akan diedit

  const AddMovie({Key? key, this.movieToEdit}) : super(key: key);

  @override
  State<AddMovie> createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  String selectedCategory = 'now';

  // Buat controller untuk setiap TextFormField
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _durasiController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _linkBannerController = TextEditingController();
  final TextEditingController _linkPosterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Jika ada data film yang akan diedit, isi TextFormField dengan nilai yang sesuai
    if (widget.movieToEdit != null) {
      _namaController.text = widget.movieToEdit!.nama;
      _deskripsiController.text = widget.movieToEdit!.desc;
      _durasiController.text = widget.movieToEdit!.durasi;
      _genreController.text = widget.movieToEdit!.genre;
      selectedCategory = widget.movieToEdit!.kategori;
      _linkBannerController.text = widget.movieToEdit!.banner;
      _linkPosterController.text = widget.movieToEdit!.poster;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Film"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _durasiController,
                decoration: InputDecoration(labelText: 'Durasi'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genre'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue as String;
                  });
                },
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                    value: 'now',
                    child: Text('Now'),
                  ),
                  DropdownMenuItem(
                    value: 'soon',
                    child: Text('Soon'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Kategori',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _linkBannerController,
                decoration: InputDecoration(labelText: 'Link Banner'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _linkPosterController,
                decoration: InputDecoration(labelText: 'Link Poster'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Simpan'),
                    onPressed: () async {
                      // Ambil nilai dari setiap controller
                      String nama = _namaController.text;
                      String deskripsi = _deskripsiController.text;
                      String durasi = _durasiController.text;
                      String genre = _genreController.text;
                      String kategori = selectedCategory;
                      String linkBanner = _linkBannerController.text;
                      String linkPoster = _linkPosterController.text;

                      // Buat objek movie berdasarkan input pengguna
                      movie film = movie(
                        banner: linkBanner,
                        desc: deskripsi,
                        durasi: durasi,
                        genre: genre,
                        nama: nama,
                        poster: linkPoster,
                        kategori: kategori,
                      );

                      try {
                        if (widget.movieToEdit != null) {
                          // Jika ini adalah mode edit, perbarui data film
                          await Database.updateMovie(
                              nama: nama, updatedMovie: film);
                        } else {
                          // Jika ini adalah mode tambah, tambahkan data film baru
                          await Database.tambahMovie(item: film);
                        }
                        Navigator.of(context).pop();
                      } catch (e) {
                        // Terjadi kesalahan saat menyimpan atau memperbarui data
                        print(e);
                        // Tampilkan pesan kesalahan ke pengguna jika diperlukan
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Hapus controller saat widget di dispose untuk menghindari memory leak
    _namaController.dispose();
    _deskripsiController.dispose();
    _durasiController.dispose();
    _genreController.dispose();
    _linkBannerController.dispose();
    _linkPosterController.dispose();
    super.dispose();
  }
}
