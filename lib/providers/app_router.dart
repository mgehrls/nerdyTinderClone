import 'package:fantascan/models/app_page_extension.dart';
import 'package:fantascan/providers/app_state_provider.dart';
import 'package:fantascan/screens/onboard_screen.dart';
import 'package:fantascan/screens/swipe_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            builder: (context, state) => SwipeScreen(
                  context: context,
                  title: 'Swipe screen',
                )),
        GoRoute(
            path: AppPage.onboard.routePath,
            name: AppPage.onboard.routeName,
            builder: (context, state) => const OnBoardScreen()),
      ],
      redirect: (context, state) {
        // define the named path of onboard screen
        final String onboardPath =
            state.namedLocation(AppPage.onboard.routeName); //#4.1

        // Checking if current path is onboarding or not
        bool isOnboarding = state.location == onboardPath; //#4.2

        // check if sharedPref as onBoardCount key or not
        //if is does then we won't onboard else we will
        bool toOnboard =
            prefs.containsKey('onBoardCount') ? false : true; //#4.3

        //#4.4
        if (toOnboard) {
          // return null if the current location is already OnboardScreen to prevent looping
          return isOnboarding ? null : onboardPath;
        }
        // returning null will tell router to don't mind redirect section
        return null; //#4.5
        //=======================change #4  end===========/
      });
}
