import 'package:fantascan/models/app_page_extension.dart';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:fantascan/providers/db_provider.dart';
import 'package:fantascan/screens/chat_screen.dart';
import 'package:fantascan/screens/profile_create_screen.dart';
import 'package:fantascan/screens/login_screen.dart';
import 'package:fantascan/screens/onboard_screen.dart';
import 'package:fantascan/screens/profile_screen.dart';
import 'package:fantascan/screens/registration_screen.dart';
import 'package:fantascan/screens/settings_screen.dart';
import 'package:fantascan/screens/swipe_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

DbProvider dbProvider = DbProvider();

class AppRouter {
  AppRouter({
    required this.appStateProvider,
    required this.prefs,
  });
  AppStateProvider appStateProvider;
  late SharedPreferences prefs;
  get router => _router;

  late final _router = GoRouter(
      refreshListenable: appStateProvider,
      initialLocation: "/",
      routes: [
        GoRoute(
          path: AppPage.home.routePath,
          name: AppPage.home.routeName,
          builder: (context, state) => Scaffold(
              body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SwipeScreen(
                  title: AppPage.home.routePageTitle,
                  context: context,
                );
              } else {
                return const LoginWidget();
              }
            },
          )),
        ),
        GoRoute(
            path: AppPage.onboard.routePath,
            name: AppPage.onboard.routeName,
            builder: (context, state) => const OnBoardScreen()),
        GoRoute(
            path: AppPage.chat.routePath,
            name: AppPage.chat.routeName,
            builder: (context, state) => const ChatScreen()),
        GoRoute(
            path: AppPage.register.routePath,
            name: AppPage.register.routeName,
            builder: (context, state) => const RegistrationWidget()),
        GoRoute(
          path: AppPage.profileCreate.routePath,
          name: AppPage.profileCreate.routeName,
          builder: (context, state) => const ProfileCreateScreen(),
        ),
        GoRoute(
          path: AppPage.profile.routePath,
          name: AppPage.profile.routeName,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppPage.settings.routePath,
          name: AppPage.settings.routeName,
          builder: (context, state) => SettingsScreen(
            context: context,
          ),
        ),
      ],
      redirect: (context, state) {
        //define paths for redirect
        final String profileCreatePath =
            state.namedLocation(AppPage.profileCreate.routeName);
        final String onboardPath =
            state.namedLocation(AppPage.onboard.routeName);
        bool isOnboarding = state.location == onboardPath;
        // check if sharedPref as onBoardCount key or not
        //if is does then we won't onboard else we will
        bool toOnboard = prefs.containsKey('onBoardCount') ? false : true;
        bool toProfileCreate =
            prefs.containsKey('profileCreated') ? false : true;

        if (toProfileCreate) {
          // return null if the current location is already ProfileCreateScreen to prevent looping
          return isOnboarding || state.location == profileCreatePath
              ? null
              : profileCreatePath;
        } else if (toOnboard) {
          // return null if the current location is already OnboardScreen to prevent looping
          return isOnboarding ? null : onboardPath;
        }
        // returning null will tell router to don't mind redirect section
        return null;
      });
}
