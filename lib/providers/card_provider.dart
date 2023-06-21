import 'package:fantascan/models/user_model.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { interested, notInterested, favorited, blocked }

class CardProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<User> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = _position.dx;

    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition(DragEndDetails details) {
    _isDragging = false;
    final status = getStatus();

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: status.toString());
    }

    switch (status) {
      case CardStatus.interested:
        like();
        break;
      case CardStatus.notInterested:
        notInterested();
        break;
      case CardStatus.favorited:
        favorite();
        break;
      case CardStatus.blocked:
        blocked();
        break;
      default:
        resetPosition();
        break;
    }

    notifyListeners();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void notInterested() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void favorite() {
    _angle = 0;
    _position += Offset(0, -2 * _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  void blocked() {
    _angle = 0;
    _position += Offset(0, 2 * _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_users.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));

    _users.removeLast();

    resetPosition();
    notifyListeners();
  }

  CardStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    const delta = 100;

    if (x > delta) {
      return CardStatus.interested;
    } else if (x < -delta) {
      return CardStatus.notInterested;
    } else if (y < delta) {
      return CardStatus.favorited;
    } else if (y > delta) {
      return CardStatus.blocked;
    }
  }

  void resetPosition() {
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  void setScreenSize(Size size) {
    _screenSize = size;
    notifyListeners();
  }

  void resetUsers() {
    _users = <User>[
      const User(
          name: "Pete",
          age: 26,
          email: "first user",
          urlImagePrimary:
              "https://images.unsplash.com/photo-1632333525618-808950db9503?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80"),
      const User(
          name: "Chris",
          age: 24,
          email: "second user",
          urlImagePrimary:
              "https://images.unsplash.com/photo-1560298803-1d998f6b5249?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80"),
      const User(
          name: "Jenna",
          age: 21,
          email: "third user",
          urlImagePrimary:
              "https://images.unsplash.com/photo-1581661701347-6e695689365b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y29zcGxheXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60"),
      const User(
          name: "Marsha",
          age: 32,
          email: "fourth user",
          urlImagePrimary:
              "https://images.unsplash.com/photo-1616461046183-f62780d4f879?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=764&q=80"),
    ].reversed.toList();

    notifyListeners();
  }
}
