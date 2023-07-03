// Create enum to represent different routes
enum AppPage {
  onboard,
  auth,
  home,
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

      default:
        return "/";
    }
  }

// for named routes
  String get routeName {
    switch (this) {
      case AppPage.home:
        return "HOME";

      case AppPage.onboard:
        return "ONBOARD";

      case AppPage.auth:
        return "AUTH";

      default:
        return "HOME";
    }
  }

// for page titles to use on appbar
  String get routePageTitle {
    switch (this) {
      case AppPage.home:
        return "Fantascan";

      default:
        return "Fantascan";
    }
  }
}
