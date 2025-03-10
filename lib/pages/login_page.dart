import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimesmss/components/my_button.dart';
import 'package:realtimesmss/components/my_text_field.dart';
import 'package:realtimesmss/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in
  void signIn() async {
    // get the auth service
    final authService = Provider.of<AuthService>(
        context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
          emailController.text,
          passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
           child:  Column(
             mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const SizedBox(height: 50),

          //logo
          Icon(
            Icons.message,
          size: 100,
            color: Colors.grey[800],
          ),
             const SizedBox(height: 50),
          //Welcome back message
           const Text(
              "Welcome back you have been missed!",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
             const SizedBox(height: 25),
          //email text field
            MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
            ),
             const SizedBox(height: 10),
          //password text field
             MyTextField(
               controller: emailController,
               hintText: "Password",
               obscureText: true,
             ),
             const SizedBox(height: 25),
          //sign in button
            MyButton(onTap:signIn, text: "Sign In"),

             const SizedBox(height: 25),
            // Not a member
             Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text("Not a member?"),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onTap,
              child: Text(
                  'Register Now',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
            )

            )
            )
          ],
          ),
          //not a member ? pleas register
        ],
      ),
    ),
    ),
    ),
    );
  }
}
