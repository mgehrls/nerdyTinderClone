import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class DbProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<UserProfileInfo> users = [];

  Future<List<UserProfileInfo>> getUsers() async {
    List<UserProfileInfo> users = [];
    await db.collection('users').get().then((value) => {
          for (var element in value.docs)
            {
              users.add(UserProfileInfo(
                uid: element.id,
                name: element.data()['name'],
                age: element.data()['age'],
                email: element.data()['email'],
                bio: element.data()['bio'],
                profilePictureUrl: element.data()['profile_picture_url'],
                secondaryPictureUrl: element.data()['secondary_picture_url'],
                tertiaryPictureUrl: element.data()['tertiary_picture_url'],
              ))
            }
        });
    return users;
  }

  Future<UserProfileInfo> getCurrentUser(uid) async {
    UserProfileInfo user = UserProfileInfo(
        uid: uid,
        name: "",
        age: 0,
        email: "",
        bio: "",
        profilePictureUrl: "",
        secondaryPictureUrl: "",
        tertiaryPictureUrl: "");
    await db.collection('users').doc(uid).get().then((value) => {
          user = UserProfileInfo(
            uid: value.id,
            name: value.data()!['name'],
            age: value.data()!['age'],
            email: value.data()!['email'],
            bio: value.data()!['bio'],
            profilePictureUrl: value.data()!['profile_picture_url'],
            secondaryPictureUrl: value.data()!['secondary_picture_url'],
            tertiaryPictureUrl: value.data()!['tertiary_picture_url'],
          )
        });
    if (user.name == "") {
      throw Exception("User not found");
    } else {
      return user;
    }
  }

  Future<void> addUser(NewUser user) async {
    await db.collection('users').doc(user.uid).set({
      'name': user.name,
      'age': user.age,
      'email': user.email,
      'bio': user.bio,
      'created_at': user.createdAt,
      'profile_picture_url': user.profilePictureUrl,
      'secondary_picture_url': user.secondaryPictureUrl,
      'tertiary_picture_url': user.tertiaryPictureUrl,
    }).onError((error, stackTrace) => print(error));
  }

  Future<bool> userExists(String uid) async {
    return await db
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.exists);
  }

  void addLikedUser(String uid) {
    db.collection('users').doc(currentUserId).update({
      'likedUsers': FieldValue.arrayUnion([uid])
    });
  }

  void addDislikedUser(String uid) {
    db.collection('users').doc(currentUserId).update({
      'dislikedUsers': FieldValue.arrayUnion([uid])
    });
  }

  void addFavedUser(String uid) {
    db.collection('users').doc(currentUserId).update({
      'favedUsers': FieldValue.arrayUnion([uid])
    });
  }

  void addBlockedUser(String uid) {
    db.collection('users').doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayUnion([uid])
    });
  }
}
