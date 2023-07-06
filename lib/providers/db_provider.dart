import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class DbProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<User>> getUsers() async {
    List<User> users = [];
    await db.collection('users').get().then((value) => {
          for (var element in value.docs)
            {
              users.add(User(
                  name: element.data()['name'],
                  age: element.data()['age'],
                  email: element.data()['email'],
                  urlImagePrimary: element.data()['urlImagePrimary']))
            }
        });
    return users;
  }
}
