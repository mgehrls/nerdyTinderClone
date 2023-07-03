import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  void hasOnboarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // set the onBoardCount to 1, the app only looks for if the value exists or not
    await prefs.setInt('onBoardCount', 1);
    // Notify listener provides converted value to all it listeneres
    notifyListeners();
  }

  void resetOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('onBoardCount');
    notifyListeners();
  }
}
