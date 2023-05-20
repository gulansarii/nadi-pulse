import 'package:postgres/postgres.dart';

class DatabaseService {


   static Future<PostgreSQLConnection> getConnection() async {
    final connection = PostgreSQLConnection("10.0.2.2", 5432, "postgres", username: "postgres", password: "12345678");

 
    return connection;
  }
}
