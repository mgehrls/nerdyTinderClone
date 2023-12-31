import 'package:fantascan/models/app_page_extension.dart';
import 'package:fantascan/providers/app_state_provider.dart';
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

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

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
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: Scaffold(
              body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData && !appStateProvider.userLoaded) {
                    return const LoginWidget();
                  } else if (snapshot.hasData && !appStateProvider.userLoaded) {
                    appStateProvider.fetchCurrentUser();
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && appStateProvider.userLoaded) {
                    return HomeScreen(
                      title: AppPage.home.routePageTitle,
                      context: context,
                    );
                  } else {
                    print(
                        "${snapshot.connectionState}, ${appStateProvider.userLoaded}, ${snapshot.hasData}");
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppPage.profileCreate.routePath,
          name: AppPage.profileCreate.routeName,
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const ProfileCreateScreen(),
          ),
        ),
        GoRoute(
            path: AppPage.onboard.routePath,
            name: AppPage.onboard.routeName,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const OnBoardScreen(),
                ),
            builder: (context, state) => const OnBoardScreen()),
        GoRoute(
            path: AppPage.chat.routePath,
            name: AppPage.chat.routeName,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const ChatScreen(),
                ),
            builder: (context, state) => const ChatScreen()),
        GoRoute(
            path: AppPage.register.routePath,
            name: AppPage.register.routeName,
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const RegistrationWidget(),
                ),
            builder: (context, state) => const RegistrationWidget()),
        GoRoute(
          path: AppPage.profile.routePath,
          name: AppPage.profile.routeName,
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
          ),
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppPage.settings.routePath,
          name: AppPage.settings.routeName,
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: SettingsScreen(
              context: context,
            ),
          ),
          builder: (context, state) => SettingsScreen(
            context: context,
          ),
        ),
      ],
      redirect: (context, state) {
        final String onboardPath =
            state.namedLocation(AppPage.onboard.routeName);
        final String profileCreatePath =
            state.namedLocation(AppPage.profileCreate.routeName);
        bool isOnboarding = state.location == onboardPath;
        bool toOnboard = prefs.getBool('onBoarded')! ? false : true;
        bool profileCreated = prefs.getBool('profileCreated')! ? true : false;
        bool isCreatingProfile = state.location == profileCreatePath;

        if (toOnboard) {
          // return null if the current location is already OnBoardScreen to prevent looping
          return isOnboarding ? null : onboardPath;
        } else if (!profileCreated) {
          return isCreatingProfile ? null : profileCreatePath;
        }
        // returning null will tell router to don't mind redirect section
        return null;
      });
}
