import 'package:flutter/material.dart';

Widget loadingWidget(context) {
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
      child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Center(
            child: CircularProgressIndicator(),
          ))));
}
