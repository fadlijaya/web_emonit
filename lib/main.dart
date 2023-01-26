import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_emonit/admin_view.dart';
import 'package:web_emonit/firebase_options.dart';
import 'package:web_emonit/login_view.dart';
import 'package:web_emonit/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'e-Monit',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: kWhite,
          fontFamily: 'Montserrat', 
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: kWhite),
          ),),
      home: const LoginView()
    );
  }
}
