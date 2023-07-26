import 'dart:io';
import 'package:fantascan/models/user_model.dart';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/db_provider.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileCreateScreenState();
  }
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
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
          child: SingleChildScrollView(
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
                  const SizedBox(height: 8),
                  Text(
                    imageError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nameError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ageError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: bioController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bio',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bioError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      submitNewUser();
                    },
                    child: const Text('Test Submit'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      provider.createProfileComplete(context);
                    },
                    child: const Text('Skip ProfileCreate'),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void submitNewUser() async {
    AppStateProvider provider =
        Provider.of<AppStateProvider>(context, listen: false);

    if (checkImage() && checkOtherFields()) {
      try {
        String profilePictureUrl = await imageOneRef
            .putFile(image!)
            .then((p0) => imageOneRef.getDownloadURL());
        String secondaryPictureUrl = await imageTwoRef
            .putFile(image2!)
            .then((p0) => imageTwoRef.getDownloadURL());
        String tertiaryPictureUrl = await imageThreeRef
            .putFile(image3!)
            .then((p0) => imageThreeRef.getDownloadURL());

        newUser = NewUser(
          uid: userID!,
          name: nameController.text.trim(),
          age: int.parse(ageController.text.trim()),
          bio: bioController.text.trim(),
          email: userEmail!,
          createdAt: DateTime.now(),
          profilePictureUrl: profilePictureUrl,
          secondaryPictureUrl: secondaryPictureUrl,
          tertiaryPictureUrl: tertiaryPictureUrl,
        );
      } on FirebaseException catch (e) {
        print(e);
      } finally {
        Provider.of<DbProvider>(context, listen: false)
            .addUser(newUser)
            .onError((error, stackTrace) => print(error));
        provider.createProfileComplete(context);
        provider.fetchCurrentUser();
      }
    }
  }

  void goHome() {
    GoRouter.of(context).go('/');
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

  bool checkOtherFields() {
    bool name = false;
    bool age = false;
    bool bio = false;

    if (nameController.text.trim().isNotEmpty) {
      name = true;
    } else {
      setState(() {
        nameError = "Please enter your name";
      });
    }
    if (ageController.text.trim().isNotEmpty) {
      age = true;
    } else {
      setState(() {
        ageError = "Please enter your age";
      });
    }
    if (bioController.text.trim().isNotEmpty) {
      bio = true;
    } else {
      setState(() {
        bioError = "Please enter your bio";
      });
    }

    if (name && age && bio) {
      return true;
    } else {
      return false;
    }
  }

  bool checkImage() {
    if (image != null && image2 != null && image3 != null) {
      return true;
    } else {
      setState(() {
        imageError = "Please select 3 photos";
      });
      return false;
    }
  }
}
