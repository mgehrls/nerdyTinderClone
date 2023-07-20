import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class DbProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
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

  Future<void> addUser(NewUser user) async {
    print(user.uid);
    print(user.name);
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

  Future<bool> checkUser(String uid) async {
    return await db
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.exists);
  }
}
