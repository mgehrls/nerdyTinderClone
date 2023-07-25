import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantascan/models/user_model.dart';
import 'package:fantascan/providers/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  UserProfileInfo? _currentUser;
  UserProfileInfo? get currentUser => _currentUser;
  bool userLoaded = false;

  Future<UserProfileInfo> fetchCurrentUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => {
              _currentUser = UserProfileInfo(
                uid: value.id,
                name: value.data()?['name'],
                age: value.data()?['age'],
                email: value.data()?['email'],
                bio: value.data()?['bio'],
                profilePictureUrl: value.data()?['profile_picture_url'],
                secondaryPictureUrl: value.data()?['secondary_picture_url'],
                tertiaryPictureUrl: value.data()?['tertiary_picture_url'],
              ),
              userLoaded = true
            });

    notifyListeners();
    return _currentUser!;
  }

  signOutUser() {
    _currentUser = null;
    userLoaded = false;
    notifyListeners();
  }

  Future<bool> isProfileCreated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get the onBoardCount value. If the value does not exist, return 0
    bool? profileCreated = prefs.getBool('profileCreated') ?? false;
    // Notify listener provides converted value to all it listeneres
    notifyListeners();
    return profileCreated;
  }

  void hasOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // set the onBoardCount to 1, the app only looks for if the value exists or not
    await prefs.setBool('onBoarded', true);
    // Notify listener provides converted value to all it listeneres
    notifyListeners();
  }

  void profileCreated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // set the onBoardCount to 1, the app only looks for if the value exists or not
    await prefs.setBool('profileCreated', true);
    // Notify listener provides converted value to all it listeneres
    notifyListeners();
  }

  resetProfileCreated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('profileCreated', false);
    notifyListeners();
  }

  void resetOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onBoarded', false);
    notifyListeners();
  }
}
