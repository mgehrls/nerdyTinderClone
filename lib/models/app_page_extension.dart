// Create enum to represent different routes
enum AppPage {
  onboard,
  auth,
  home,
  chat,
  register,
  profileCreate,
  profile,
  settings,
}

extension AppPageExtension on AppPage {
  // create path for routes
  String get routePath {
    switch (this) {
      case AppPage.home:
        return "/";

      case AppPage.onboard:
        return "/onboard";

      case AppPage.auth:
        return "/auth";

      case AppPage.chat:
        return "/chat";

      case AppPage.register:
        return "/register";

      case AppPage.profileCreate:
        return "/profileCreate";

      case AppPage.profile:
        return "/profile";

      case AppPage.settings:
        return "/settings";

      default:
        return "/";
    }
  }

// for named routes
  String get routeName {
    switch (this) {
      case AppPage.home:
        return "HOME";

      case AppPage.chat:
        return "CHAT";

      case AppPage.onboard:
        return "ONBOARD";

      case AppPage.auth:
        return "AUTH";

      case AppPage.register:
        return "REGISTER";

      case AppPage.profileCreate:
        return "INTRO";

      case AppPage.profile:
        return "PROFILE";

      case AppPage.settings:
        return "SETTINGS";

      default:
        return "HOME";
    }
  }

// for page titles to use on appbar
  String get routePageTitle {
    switch (this) {
      case AppPage.home:
        return "Fantascan";

      case AppPage.chat:
        return "FantaChat";

      default:
        return "Fantascan";
    }
  }
}
