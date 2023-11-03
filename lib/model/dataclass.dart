import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utsprak/model/dbservices.dart';

CollectionReference tblMovie = FirebaseFirestore.instance.collection("FILM");
CollectionReference tblBooking =
    FirebaseFirestore.instance.collection("booking");
CollectionReference tblUser = FirebaseFirestore.instance.collection("user");

class Database {
  // ------------- METHOD TAMPIL SEMUA DATA -------------
  static Stream<QuerySnapshot> getData() {
    return tblMovie.snapshots();
  }

  static Stream<QuerySnapshot> getBookingData() {
    return tblBooking.snapshots();
  }

  // ------------- METHOD TAMPIL DATA FILTER-------------
  static Future<movie> getMovie({required String nama}) async {
    QuerySnapshot querySnapshot =
        await tblMovie.where("nama", isEqualTo: nama).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return movie.fromJson(data);
    } else {
      throw Exception("Data dengan nama $nama tidak ditemukan");
    }
  }

  static Future<movie> getMovieGrid() async {
    QuerySnapshot querySnapshot = await tblMovie.get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return movie.fromJson(data);
    } else {
      throw Exception("Data tidak ditemukan");
    }
  }

  static Future<MyUser> getUser({required String email}) async {
    QuerySnapshot querySnapshot =
        await tblUser.where("email", isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return MyUser.fromJson(data); // Sesuaikan dengan model data pengguna Anda
    } else {
      throw Exception("Data dengan email $email tidak ditemukan");
    }
  }

  static Future<List<Booking>> getBookingsByFilmAndWaktu({
    required String film,
    required String waktu,
  }) async {
    QuerySnapshot querySnapshot = await tblBooking
        .where("film", isEqualTo: film)
        .where("jam", isEqualTo: waktu)
        .get();

    List<Booking> bookings = [];

    for (var docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      bookings.add(Booking.fromJson(data));
    }
    return bookings;
  }

  static Future<List<Booking>> getBookingsByEmail(
      {required String email}) async {
    QuerySnapshot querySnapshot =
        await tblBooking.where("email", isEqualTo: email).get();

    List<Booking> bookings = [];

    for (var docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      bookings.add(Booking.fromJson(data));
    }

    return bookings;
  }

  static Future<void> updateMovie(
      {required String nama, required movie updatedMovie}) async {
    // Dapatkan referensi dokumen berdasarkan nama film
    DocumentReference docRef = tblMovie.doc(nama);

    try {
      // Perbarui data film dengan data yang baru
      await docRef.update(updatedMovie.toJson());
      print("Data film berhasil diperbarui");
    } catch (e) {
      print("Error saat memperbarui data film: $e");
      throw e;
    }
  }

  static Future<void> deleteMovie({required String nama}) async {
    DocumentReference docRef = tblMovie.doc(nama);

    try {
      await docRef.delete();
      print("Data film berhasil dihapus");
    } catch (e) {
      print("Error saat menghapus data film: $e");
      throw e;
    }
  }

// ------------- METHOD TAMBAH -------------

  static Future<void> tambahUser({required MyUser user}) async {
    DocumentReference docref = tblUser.doc(user.email);
    await docref
        .set(user.toJson())
        .whenComplete(() => "Pengguna berhasil ditambahkan")
        .catchError((e) => print(e));
  }

  static Future<void> tambahMovie({required movie item}) async {
    DocumentReference docref = tblMovie.doc(item.nama);
    await docref
        .set(item.toJson())
        .whenComplete(() => "data berhasil di input")
        .catchError((e) => print(e));
  }

  static Future<void> tambahBooking({required Booking booking}) async {
    DocumentReference docref = tblBooking.doc();
    await docref
        .set(booking.toJson())
        .whenComplete(() => "Booking berhasil")
        .catchError((e) => print(e));
  }
}
