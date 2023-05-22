// import 'http';

import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationService {
 static void showNotification(
      {required String title,required String message, required String fcmToken}) async {
    var headers = {
      'Authorization':
          'KEY=AAAABO-QnMw:APA91bELxnzIoVEuqP5nYdA4bk-ZCyUPSXadYdwmBNuF3yTMslixX92p2Mc8RXnaKY5gJDdqZiFVrMqCtqfwOavs79p45h-G_VZxySyXEaaihNsUzvm53cXbk9deBJoIQFYyKGmuWCnz',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": fcmToken,
      "collapse_key": "type_a",
      "notification": {
        "body": message,
        "title": title
      },
      "data": {
        "body": message,
        "title": title,
        "key_1": "Value for key_1",
        "key_2": "Value for key_2"
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
