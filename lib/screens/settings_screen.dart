import 'package:fantascan/components/header.dart';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:fantascan/providers/db_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/card_provider.dart';

class SettingsScreen extends StatefulWidget {
  BuildContext context;

  SettingsScreen({super.key, required this.context});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appStateProvider = Provider.of<AppStateProvider>(context);
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
              children: [
                buildHeader(context),
                const SizedBox(height: 8),
                Expanded(
                    child: Column(
                  children: [
                    const Text('Setting Screen'),
                    ElevatedButton(
                        onPressed: () {
                          appStateProvider.resetOnboarding();
                        },
                        child: const Text('Reset Onboarding')),
                    ElevatedButton(
                        onPressed: () {
                          appStateProvider.resetProfileCreated();
                        },
                        child: const Text('Reset Profile Created')),
                    ElevatedButton(
                        onPressed: () {
                          getUsers();
                        },
                        child: const Text('Get Users')),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut().whenComplete(
                              () => {
                                    appStateProvider.signOutUser(),
                                    GoRouter.of(context).go('/')
                                  });
                        },
                        child: const Text('Sign Out')),
                  ],
                )),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getUsers() async {
    final db = Provider.of<DbProvider>(context, listen: false);
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    cardProvider.setUsers(await db.getUsers());
  }
}
