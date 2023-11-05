class movie {
  final String banner;
  final String desc;
  final String durasi;
  final String genre;
  final String nama;
  final String poster;
  final String kategori; // Tambahkan kategori

  movie({
    required this.banner,
    required this.desc,
    required this.durasi,
    required this.genre,
    required this.nama,
    required this.poster,
    required this.kategori, // Inisialisasi kategori
  });

  Map<String, dynamic> toJson() {
    return {
      "banner": banner,
      "desc": desc,
      "durasi": durasi,
      "genre": genre,
      "nama": nama,
      "poster": poster,
      "kategori": kategori, // Tambahkan kategori ke metode toJson
    };
  }

  factory movie.fromJson(Map<String, dynamic> json) {
    return movie(
      banner: json["banner"],
      desc: json["desc"],
      durasi: json["durasi"],
      genre: json["genre"],
      nama: json["nama"],
      poster: json["poster"],
      kategori: json["kategori"], // Ambil kategori dari data JSON
    );
  }
}

class Booking {
  final String email;
  final String jam;
  final String film;
  final String kursi;

  Booking({
    required this.email,
    required this.jam,
    required this.film,
    required this.kursi,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "jam": jam,
      "film": film,
      "kursi": kursi,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      email: json["email"],
      jam: json["jam"],
      film: json["film"],
      kursi: json["kursi"],
    );
  }
}

class MyUser {
  final String nama;
  final String email;
  final String noTlp;
  final String alamat;
  final String kategori;

  MyUser({
    required this.nama,
    required this.email,
    required this.noTlp,
    required this.alamat,
    required this.kategori,
  });

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "email": email,
      "noTlp": noTlp,
      "alamat": alamat,
      "kategori": kategori,
    };
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      nama: json["nama"],
      email: json["email"],
      noTlp: json["noTlp"],
      alamat: json["alamat"],
      kategori: json["kategori"],
    );
  }
}
