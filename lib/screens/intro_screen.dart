import 'dart:io';

import 'package:fantascan/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IntroScreenState();
  }
}

class _IntroScreenState extends State<IntroScreen> {
  String? name;
  int? age;
  File? image;
  File? image2;
  File? image3;

  @override
  Widget build(BuildContext context) {
    AppStateProvider provider = Provider.of<AppStateProvider>(context);
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                      ),
                    ),
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                      ),
                    ),
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: const BoxDecoration(color: Colors.pinkAccent),
                    )
                  ],
                ),
                const Text(
                  'This is where the intro goes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MaterialButton(
                    color: Colors.blue,
                    child: const Text("Gallery",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    }),
                MaterialButton(
                    color: Colors.blue,
                    child: const Text("Camera",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    }),
                const SizedBox(
                  height: 16,
                ),
                image != null
                    ? Image.file(image!, height: 100, width: 100)
                    : const Text("No Image Selected"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    provider.profileCreated();
                    GoRouter.of(context).go('/');
                  },
                  child: const Text('Skip Intro'),
                ),
                const SizedBox(height: 16),
              ]),
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
