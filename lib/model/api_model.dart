class Movie {
  String? idMovie; // Tambahkan idMovie
  String? banner;
  String? desc;
  String? durasi;
  String? genre;
  String? name;
  String? poster;
  String? kategori;

  Movie(
      {this.idMovie, // Tambahkan idMovie ke dalam konstruktor
      this.banner,
      this.desc,
      this.durasi,
      this.genre,
      this.name,
      this.poster,
      this.kategori});

  Movie.fromJson(Map<String, dynamic> json) {
    idMovie = json['idMovie']; // Ambil idMovie dari data JSON
    banner = json['banner'];
    desc = json['desc'];
    durasi = json['durasi'];
    genre = json['genre'];
    name = json['name'];
    poster = json['poster'];
    kategori = json['kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idMovie'] = this.idMovie; // Tambahkan idMovie ke dalam metode toJson
    data['banner'] = this.banner;
    data['desc'] = this.desc;
    data['durasi'] = this.durasi;
    data['genre'] = this.genre;
    data['name'] = this.name;
    data['poster'] = this.poster;
    data['kategori'] = this.kategori;
    return data;
  }
}

class MyUser {
  String? idUser;
  String? nama;
  String? email;
  String? noTlp;
  String? alamat;
  String? kategori;

  MyUser({
    this.idUser,
    this.nama,
    this.email,
    this.noTlp,
    this.alamat,
    this.kategori,
  });

  MyUser.fromJson(Map<String, dynamic> json) {
    idUser = json['idMovie']; // Change this to 'idUser'
    nama = json['nama'];
    email = json['email'];
    noTlp = json['noTlp'];
    alamat = json['alamat'];
    kategori = json['kategori'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser; // Change this to 'idUser'
    data['nama'] = this.nama;
    data['email'] = this.email;
    data['noTlp'] = this.noTlp;
    data['alamat'] = this.alamat;
    data['kategori'] = this.kategori;
    return data;
  }
}

class Booking {
  String? idBooking;
  final String email;
  final String jam;
  final String film;
  final String kursi;

  Booking({
    this.idBooking,
    required this.email,
    required this.jam,
    required this.film,
    required this.kursi,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_booking": idBooking,
      "email": email,
      "jam": jam,
      "film": film,
      "kursi": kursi,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      idBooking: json["id_booking"],
      email: json["email"],
      jam: json["jam"],
      film: json["film"],
      kursi: json["kursi"],
    );
  }
}

class BookingWithMovieInfo {
  final Booking booking;
  final Movie movieInfo;

  BookingWithMovieInfo({
    required this.booking,
    required this.movieInfo,
  });
}
