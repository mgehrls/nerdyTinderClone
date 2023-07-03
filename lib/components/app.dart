import 'package:fantascan/providers/app_state_provider.dart';
import 'package:fantascan/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_router.dart';

class MyApp extends StatefulWidget {
// Declared fields prefs which we will pass to the router class
  //=======================change #1==========/
  SharedPreferences prefs;
  MyApp({required this.prefs, Key? key}) : super(key: key);
  //=======================change #1 end===========/
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        //=======================change #2==========/
        // Remove previous Provider call and create new proxyprovider that depends on AppStateProvider
        ProxyProvider<AppStateProvider, AppRouter>(
            update: (context, appStateProvider, _) => AppRouter(
                appStateProvider: appStateProvider, prefs: widget.prefs)),
        ChangeNotifierProvider(create: (context) => CardProvider()),
      ],
      //=======================change #2 end==========/
      child: Builder(
        builder: ((context) {
          final GoRouter router = Provider.of<AppRouter>(context).router;

          return MaterialApp.router(
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              backButtonDispatcher: router.backButtonDispatcher);
        }),
      ),
    );
  }
}
