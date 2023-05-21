import 'package:postgres/postgres.dart';

class DatabaseService {
  static Future<PostgreSQLConnection> getConnection() async {
    // PostgreSQLConnection connection = PostgreSQLConnection(
    //     "10.0.2.2", 5432, "postgres",
    //     username: "postgres", password: "12345678");
    PostgreSQLConnection connection = PostgreSQLConnection(
        "db.ensydxxnswzsajkbcfgn.supabase.co", 5432, "postgres",
        username: "postgres", password: "RIYGU3lO5mz2Le6u");
    await connection
        .open()
        .then((value) => print("Connected to databasesssss"))
        .catchError((e) {
      print(e);
      print("Connection failed");
    });

    return connection;
  }
}
