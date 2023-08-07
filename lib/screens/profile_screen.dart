import 'dart:io';
import 'package:fantascan/components/header.dart';
import 'package:fantascan/models/user_model.dart';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  String? nameError = "";
  final ageController = TextEditingController();
  String? ageError = "";
  final bioController = TextEditingController();
  String? bioError = "";
  File? image;
  File? image2;
  File? image3;
  String? imageError = "";
  String? userID = FirebaseAuth.instance.currentUser!.uid;
  String? userEmail = FirebaseAuth.instance.currentUser!.email;
  String? primaryPictureUrl = "";
  String? secondaryPictureUrl = "";
  String? tertiaryPictureUrl = "";

  late NewUser newUser = NewUser(
    uid: userID!,
    name: nameController.text.trim(),
    age: int.parse(ageController.text.trim()),
    bio: bioController.text.trim(),
    email: userEmail!,
    createdAt: DateTime.now(),
    profilePictureUrl: "",
    secondaryPictureUrl: "",
    tertiaryPictureUrl: '',
  );

  final storage = FirebaseStorage.instance;
  // ignore: prefer_interpolation_to_compose_strings
  late Reference imageOneRef;
  late Reference imageTwoRef;
  late Reference imageThreeRef;

  @override
  Widget build(BuildContext context) {
    AppStateProvider provider = Provider.of<AppStateProvider>(context);
    UserProfileInfo? user = provider.currentUser;

    if (user != null) {
      userID = user.uid;
      userEmail = user.email;
      nameController.text = user.name;
      ageController.text = user.age.toString();
      bioController.text = user.bio;
      primaryPictureUrl = user.profilePictureUrl;
      secondaryPictureUrl = user.secondaryPictureUrl;
      tertiaryPictureUrl = user.tertiaryPictureUrl;
    }

    imageOneRef = storage.ref().child('images/$userID/1');
    imageTwoRef = storage.ref().child('images/$userID/2');
    imageThreeRef = storage.ref().child('images/$userID/3');

    return Container(
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
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildHeader(context),
                          const SizedBox(height: 32),
                          buildPictureSection(),
                          const SizedBox(height: 16),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  user?.name ?? "Error: Name not found.",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user?.age.toString() ??
                                      "Error: Age not found.",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user?.bio ?? "Error: Bio not found.",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ])))));
  }

  Widget buildPictureSection() {
    return Stack(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(secondaryPictureUrl!),
          ),
          const SizedBox(
            width: 30,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(tertiaryPictureUrl!),
          ),
        ],
      ),
      Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage(primaryPictureUrl!),
        ),
      ),
      Positioned(
        bottom: 0,
        right: MediaQuery.of(context).size.width / 4,
        child: CircleAvatar(
          backgroundColor: Colors.grey[800]?.withOpacity(.7),
          child: IconButton(
              onPressed: () {
                print("edit");
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
              )),
        ),
      ),
    ]);
  }
}
