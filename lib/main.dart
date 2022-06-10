import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/routes/auth_route.dart';
import 'package:flutter_chat_app/routes/chat_route.dart';
import 'package:flutter_chat_app/routes/splash_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCn-SPn7jEeAbwUCuXUEt838_FafXpRWBE",
          authDomain: "flutter-chat-6944a.firebaseapp.com",
          projectId: "flutter-chat-6944a",
          storageBucket: "flutter-chat-6944a.appspot.com",
          messagingSenderId: "1027452413147",
          appId: "1:1027452413147:web:4ea632c8d4a5e590a898fe",
          measurementId: "G-9KKHXG2EHY"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatMO',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        backgroundColor: Colors.pink,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
        ).copyWith(
          secondary: Colors.deepPurple,
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashRoute();
          }
          if (userSnapshot.hasData) {
            return const ChatRoute();
          }
          return const AuthRoute();
        },
      ),
    );
  }
}
