import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildHeader(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
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
          child: const Row(
            children: [
              Icon(Icons.align_horizontal_center_outlined,
                  color: Colors.white, size: 32),
              SizedBox(width: 4),
              Text(
                'Fantascan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
      const Spacer(),
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
          child: const Icon(Icons.chat_outlined, color: Colors.white, size: 32))
    ],
  );
}
