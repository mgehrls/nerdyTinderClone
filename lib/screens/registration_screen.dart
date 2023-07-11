import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/db_provider.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationWidgetState();
  }
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String errorCode = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.teal,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  GoRouter.of(context).go('/');
                },
              ),
              const Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              buildTextFields(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.lock_open),
                    onPressed: () {
                      register(context);
                    },
                    label: const Text('Register'),
                  ),
                ],
              ),
              errorCode != ""
                  ? Text(
                      errorCode,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFields() {
    return Column(
      children: [
        TextField(
          controller: emailController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future register(context) async {
    final db = Provider.of<DbProvider>(context, listen: false);
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      return;
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) async => {
                if (await db.checkUser(FirebaseAuth.instance.currentUser!.uid))
                  {GoRouter.of(context).go('/')}
                else
                  {GoRouter.of(context).go('/intro')}
              });
    } catch (e) {
      setState(() {
        errorCode = e.toString();
      });
    }

    if (FirebaseAuth.instance.currentUser != null) {
      GoRouter.of(context).go('/intro');
    }
  }
}
