import 'package:fantascan/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

void onSubmitDone(AppStateProvider stateProvider, BuildContext context) {
  // When user pressed skip/done button we'll finally set onboardCount integer
  stateProvider.hasOnboarded();
  // After that onboard state is done we'll go to homepage.
  GoRouter.of(context).go("/");
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          children: [
            const Text("This is Onboard Screen"),
            ElevatedButton(
                onPressed: () => onSubmitDone(appStateProvider, context),
                child: const Text("Done/Skip"))
          ],
        )),
      ),
    );
  }
}
