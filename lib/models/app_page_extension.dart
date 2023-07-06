// Create enum to represent different routes
enum AppPage {
  onboard,
  auth,
  home,
  chat,
  login,
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

      case AppPage.login:
        return "/login";

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

      case AppPage.login:
        return "LOGIN";

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
