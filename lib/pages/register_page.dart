import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimesmss/services/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password do not match"),
        ),
      );
      return;
    }
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
            child: Column(
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
                //Create an account
                const Text(
                  "Let us create the account for you!",
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
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                //Confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm a Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                //sign up button
                MyButton(onTap: signUp, text: "Sign Up"),

                const SizedBox(height: 25),
                // Not a member register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member"),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Please log in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
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
