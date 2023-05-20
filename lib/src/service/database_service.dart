import 'package:postgres/postgres.dart';

class DatabaseService {
   static  Future<PostgreSQLConnection> getConnection() async {
      print("start Connected to database");

    PostgreSQLConnection connection = PostgreSQLConnection("10.0.2.2", 5432, "postgres", username: "postgres", password: "12345678");
    connection.open().then((value) => print("Connected to databasesssss")) .catchError((e) {
      print(e);
      print("Connection failed");
    });
          print("end Connected to database");

    return connection;
  }
}
