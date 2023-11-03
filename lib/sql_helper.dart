import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Fungsi untuk membuat tabel database
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username TEXT,
        password TEXT
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql
        .openDatabase('catatan.db', version: 3, // Tingkatkan versi database
            onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
    // onUpgrade:
    //             (sql.Database database, int oldVersion, int newVersion) async {
    //   if (oldVersion < 3) {
    //     // Tambahkan perubahan skema yang diperlukan untuk versi 2
    //     await database.execute('''
    //     CREATE TABLE user (
    //       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    //       username TEXT,
    //       password TEXT
    //     )
    //   ''');
    //   }
    //   // Tambahkan blok onUpgrade lainnya untuk versi-versi berikutnya jika diperlukan
    // });
  }

  static Future<int> tambahUser(String username, String password) async {
    final db = await SQLHelper.db();
    final data = {'username': username, 'password': password};
    return await db.insert('user', data);
  }

  // Fungsi untuk menambahkan catatan ke database
  static Future<int> tambahCatatan(String judul, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {'judul': judul, 'deskripsi': deskripsi};
    return await db.insert('catatan', data);
  }

  // Fungsi untuk mengambil data catatan dari database
  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await SQLHelper.db();
    return db.query('catatan');
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('user');
  }

  static Future<int> ubahCatatan(int id, String judul, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {'judul': judul, 'deskripsi': deskripsi};
    return await db.update("catatan", data, where: "id=$id");
  }

  // Fungsi untuk menghapus catatan dari database berdasarkan ID
  static Future<int> hapusCatatan(int id) async {
    final db = await SQLHelper.db();
    return await db.delete("catatan", where: "id = ?", whereArgs: [id]);
  }
}
