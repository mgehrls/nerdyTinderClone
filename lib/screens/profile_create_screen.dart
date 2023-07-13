import 'dart:io';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileCreateScreenState();
  }
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  String? name;
  int? age;
  String? bio;
  File? image;
  File? image2;
  File? image3;
  String? userID = FirebaseAuth.instance.currentUser!.uid;

  final storage = FirebaseStorage.instance;
  // ignore: prefer_interpolation_to_compose_strings
  late Reference imageOneRef;
  late Reference imageTwoRef;
  late Reference imageThreeRef;

  @override
  Widget build(BuildContext context) {
    AppStateProvider provider = Provider.of<AppStateProvider>(context);

    imageOneRef = storage.ref().child('images/$userID/1');
    imageTwoRef = storage.ref().child('images/$userID/2');
    imageThreeRef = storage.ref().child('images/$userID/3');

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pick 3 photos of yourself!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imagePickerWidget(image, pickImage),
                    imagePickerWidget(image2, pickImage2),
                    imagePickerWidget(image3, pickImage3)
                  ],
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bio',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    try {
                      if (image != null) {
                        imageOneRef.putFile(image!);
                      }
                      if (image2 != null) {
                        imageTwoRef.putFile(image2!);
                      }
                      if (image3 != null) {
                        imageThreeRef.putFile(image3!);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('send images to bucket'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    provider.profileCreated();
                    GoRouter.of(context).go('/');
                  },
                  child: const Text('Skip ProfileCreate'),
                ),
              ]),
        ),
      ),
    );
  }

  Widget imagePickerWidget(
      File? stateImage, Future Function(ImageSource) imagePickFunction) {
    return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width / 4,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: stateImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(stateImage, fit: BoxFit.cover))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            imagePickFunction(ImageSource.camera);
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 25,
                          )),
                      IconButton(
                          onPressed: () {
                            imagePickFunction(ImageSource.gallery);
                          },
                          icon: const Icon(
                            Icons.insert_photo_outlined,
                            color: Colors.white,
                            size: 25,
                          )),
                    ],
                  )));
  }

  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final imageTemp = File(img.path);
      setState(() => image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage2(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final imageTemp = File(img.path);
      setState(() => image2 = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage3(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final imageTemp = File(img.path);
      setState(() => image3 = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
