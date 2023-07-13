import 'package:fantascan/components/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('onBoarded', false);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.black38),
  );

  await Firebase.initializeApp(
    name: 'fantascan',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(prefs: prefs));
}
