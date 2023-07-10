import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildHeader(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(5.0)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.white))),
          ),
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: const Icon(Icons.home, color: Colors.white, size: 32)),
      ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(5.0)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.white))),
          ),
          onPressed: () {
            GoRouter.of(context).go('/profile');
          },
          child: const Icon(Icons.person, color: Colors.white, size: 32)),
      ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(5.0)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.white))),
          ),
          onPressed: () {
            GoRouter.of(context).go('/chat');
          },
          child:
              const Icon(Icons.chat_outlined, color: Colors.white, size: 32)),
      ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(5.0)),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.white))),
          ),
          onPressed: () {
            GoRouter.of(context).go('/settings');
          },
          child: const Icon(Icons.settings, color: Colors.white, size: 32)),
    ],
  );
}
