import 'package:fantascan/components/header.dart';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  BuildContext context;

  ChatScreen({super.key, required this.title, required this.context});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                    const Text('Chat Screen'),
                    ElevatedButton(
                        onPressed: () {
                          appStateProvider.resetOnboarding();
                        },
                        child: const Text('Reset Onboarding')),
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
}
