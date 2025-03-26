import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimesmss/firebase_options.dart';
import 'package:realtimesmss/services/auth_gate.dart';
import 'package:realtimesmss/services/auth_service.dart';
//import 'package:realtimesmss/pages/register_page.dart';
//import 'package:realtimesmss/services/login_or_register.dart';
//import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      ChangeNotifierProvider (
        create: (context) => AuthService(),
        child: const MyApp(),
      ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );

  }
}



