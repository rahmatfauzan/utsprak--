import 'package:dio/dio.dart';
import 'package:utsprak/model/api_model.dart';

class APIServices {
  static Dio dio = Dio(); // Create a Dio instance

//========================BAGIAN MOVIE==========================================
  static Future<List<Movie>> getMovie() async {
    try {
      final response = await dio
          .get('https://bioskop-d270d-default-rtdb.firebaseio.com/movie.json');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<Movie> movies = [];
        data.forEach((key, value) {
          final movie = Movie.fromJson(value);
          movie.idMovie = key; // Menyimpan kunci dalam objek Movie
          print(key);
          movies.add(movie);
        });
        return movies;
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Movie> getMovieById(String idMovie) async {
    try {
      final response = await dio.get(
          'https://bioskop-d270d-default-rtdb.firebaseio.com/movie/${idMovie}.json');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data != null) {
          final Movie movie = Movie.fromJson(data);
          movie.idMovie = idMovie; // Menyimpan kunci dalam objek Movie
          return movie;
        } else {
          throw Exception('Movie not found for id: $idMovie');
        }
      } else {
        throw Exception('Failed to fetch movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> addMovie(Movie movie) async {
    try {
      final response = await dio.post(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/movie.json',
        data: movie.toJson(),
      );

      if (response.statusCode == 200) {
        print('Movie added successfully.');
      } else {
        throw Exception('Failed to add movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> UpdateMovie(String idMovie, Movie updatedMovie) async {
    try {
      final response = await dio.put(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/movie/${idMovie}.json',
        data: updatedMovie.toJson(),
      );

      if (response.statusCode == 200) {
        print('Movie updated successfully.');
      } else {
        throw Exception('Failed to update movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> deleteMovie(String? idMovie) async {
    try {
      final response = await dio.delete(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/movie/${idMovie}.json',
      );

      if (response.statusCode == 200) {
        print('Movie deleted successfully.');
      } else {
        throw Exception('Failed to delete movie');
      }
    } catch (e) {
      print(idMovie);
      print("eroooooooorrrrrrrrrrrr");
      throw Exception('Error: $e');
    }
  }

//========================BAGIAN USER==========================================
  static Future<MyUser> getUserByEmail(String email) async {
    try {
      final response = await dio.get(
          'https://bioskop-d270d-default-rtdb.firebaseio.com/user.json'); // Ganti dengan URL Firebase Anda

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        // Cari user dengan email yang sesuai
        for (final key in data.keys) {
          final user = MyUser.fromJson(data[key]);
          user.idUser = key;

          if (user.email == email) {
            return user;
          }
        }

        throw Exception('User with email $email not found');
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> addUser(MyUser user) async {
    try {
      final response = await dio.post(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/user.json', // Replace with your Firebase URL
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        print('User added successfully.');
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> updateUser(String idUser, MyUser updatedUser) async {
    try {
      final response = await dio.put(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/user/$idUser.json', // Replace with your Firebase URL
        data: updatedUser.toJson(),
      );

      if (response.statusCode == 200) {
        print('User updated successfully.');
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> deleteUser(String? idUser) async {
    try {
      final response = await dio.delete(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/user/$idUser.json', // Replace with your Firebase URL
      );

      if (response.statusCode == 200) {
        print('User deleted successfully.');
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Booking>> getBookingById(
      String movieId, String time) async {
    try {
      final response = await dio.get(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/booking.json', // Ganti URL sesuai dengan koleksi "booking" di Firebase Anda
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bookingData = response.data;

        // Membuat list untuk menyimpan hasil pencarian
        List<Booking> bookings = [];

        // Iterasi melalui data dan mencari booking berdasarkan movieId dan time
        bookingData.forEach((bookingId, booking) {
          if (booking['film'] == movieId && booking['jam'] == time) {
            bookings.add(Booking(
              // Pastikan Anda memiliki model Booking untuk merepresentasikan data booking
              idBooking: bookingId,
              email: booking['email'],
              film: booking['film'],
              jam: booking['jam'],
              kursi: booking['kursi'],
            ));
          }
        });

        return bookings;
      } else {
        throw Exception('Gagal mengambil data booking');
      }
    } catch (error) {
      throw Exception('Terjadi kesalahan: $error');
    }
  }

  static Future<void> addBooking(Booking booking) async {
    try {
      final response = await dio.post(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/booking.json',
        data: booking.toJson(),
      );
      if (response.statusCode == 200) {
        print('Movie added successfully.');
      } else {
        throw Exception('Failed to add booking');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<BookingWithMovieInfo>>
      getBookingDataWithMovieInfo() async {
    try {
      final response = await dio.get(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/booking.json', // Endpoint untuk tabel booking
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bookingData = response.data;
        final List<BookingWithMovieInfo> result = [];

        for (final key in bookingData.keys) {
          final bookingJson = bookingData[key];
          final Booking booking = Booking.fromJson(bookingJson);

          final movieResponse = await dio.get(
            'https://bioskop-d270d-default-rtdb.firebaseio.com/movie/${booking.film}.json/', // Endpoint untuk tabel movie dengan movieId yang sesuai
          );

          if (movieResponse.statusCode == 200) {
            final Map<String, dynamic> movieData = movieResponse.data;
            final Movie movieInfo = Movie.fromJson(movieData);

            result.add(BookingWithMovieInfo(
              booking: booking,
              movieInfo: movieInfo,
            ));
          }
        }

        return result.reversed.toList();
      } else {
        throw Exception('Gagal mengambil data booking');
      }
    } catch (error) {
      throw Exception('Terjadi kesalahan: $error');
    }
  }

  static Future<List<BookingWithMovieInfo>> getBookingUser(String email) async {
    try {
      final response = await dio.get(
        'https://bioskop-d270d-default-rtdb.firebaseio.com/booking.json', // Endpoint untuk tabel booking
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> bookingData = response.data;
        final List<BookingWithMovieInfo> result = [];

        for (final key in bookingData.keys) {
          final bookingJson = bookingData[key];
          final Booking booking = Booking.fromJson(bookingJson);

          if (booking.email == email) {
            final movieResponse = await dio.get(
              'https://bioskop-d270d-default-rtdb.firebaseio.com/movie/${booking.film}.json/', // Endpoint untuk tabel movie dengan movieId yang sesuai
            );

            if (movieResponse.statusCode == 200) {
              final Map<String, dynamic> movieData = movieResponse.data;
              final Movie movieInfo = Movie.fromJson(movieData);

              result.add(BookingWithMovieInfo(
                booking: booking,
                movieInfo: movieInfo,
              ));
            }
          }
        }

        // Urutkan hasil terbalik dengan metode reversed
        return result.reversed.toList();
      } else {
        throw Exception('Gagal mengambil data booking');
      }
    } catch (error) {
      throw Exception('Terjadi kesalahan: $error');
    }
  }
}
