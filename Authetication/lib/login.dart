import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(Icons.lock,size:100),

              const SizedBox(height:20),

              const Text(
                "Welcome back you've been missed!",
              ),

              const SizedBox(height:20),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),

              const SizedBox(height:15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),

              const SizedBox(height:20),

              ElevatedButton(
                onPressed: signIn,
                child: const Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}