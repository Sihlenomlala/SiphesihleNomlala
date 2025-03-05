import 'package:flutter/material.dart';
//import 'package:realtimesmss/pages/register_page.dart';
import 'package:realtimesmss/services/login_or_register.dart';
//import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
    );

  }
}



