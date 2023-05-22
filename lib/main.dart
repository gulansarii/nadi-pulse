import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nadi/src/utils/material_swatch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nadi/src/view/screens/splash_screen.dart';
import 'package:postgres/postgres.dart';

import 'firebase_options.dart';

var fcmToken = "";
late PostgreSQLConnection postgreSQLConnection ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  postgreSQLConnection = PostgreSQLConnection(
        "db.ensydxxnswzsajkbcfgn.supabase.co", 5432, "postgres",
        username: "postgres", password: "RIYGU3lO5mz2Le6u");
    await postgreSQLConnection
        .open()
        .then((value) => print("Connected to databasesssss"))
        .catchError((e) {
      print(e);
      print("Connection failed");
    });
  // await DatabaseService.getConnection();
  // token handling
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  fcmToken = (await messaging.getToken())!;
  print("$fcmToken this is fcm token");
  // notification handling
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    await messaging.getNotificationSettings();
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   Fluttertoast.showToast(msg: message.data['body'].toString());
  // });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((message) {
      Fluttertoast.showToast(msg: message.data['body'].toString());
    });
    //onclick notif system tray only works if app in background but not termi
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.to(() => const SplashScreen());
      print('A new onMessageOpenedApp event was published!');
      print(message.data['body'].toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nadi Pulse',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFFa1d6c9)),
      ),
      home: const SplashScreen(),
      // home: const SignInScreen(),
    );
  }
}
