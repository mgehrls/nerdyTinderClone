import 'dart:math';
import 'package:fantascan/models/user_model.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { interested, notInterested, favorited, blocked }

class CardProvider extends ChangeNotifier {
  List<UserProfileInfo> _users = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<UserProfileInfo> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

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

  String endPosition(DragEndDetails details) {
    _isDragging = false;
    final status = getStatus(force: true);

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split(".").last.toUpperCase(),
        fontSize: 32,
        backgroundColor: Colors.black,
      );
    }

    switch (status) {
      case CardStatus.interested:
        like();
        notifyListeners();
        return "liked";
      case CardStatus.notInterested:
        notInterested();
        notifyListeners();
        return "not interested";
      case CardStatus.favorited:
        favorite();
        notifyListeners();
        return "faved";
      case CardStatus.blocked:
        blocked();
        notifyListeners();
        return "blocked";
      default:
        resetPosition();
        notifyListeners();
        return "";
    }
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

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceFavorite = x.abs() < 20;

    if (force) {
      const delta = 100;

      if (x > delta) {
        return CardStatus.interested;
      } else if (x < -delta) {
        return CardStatus.notInterested;
      } else if (y < -delta && forceFavorite) {
        return CardStatus.favorited;
      } else if (y > delta) {
        return CardStatus.blocked;
      } else {
        return null;
      }
    } else {
      const delta = 20;

      if (x > delta) {
        return CardStatus.interested;
      } else if (x < -delta) {
        return CardStatus.notInterested;
      } else if (y < -delta && forceFavorite) {
        return CardStatus.favorited;
      } else if (y > delta) {
        return CardStatus.blocked;
      } else {
        return null;
      }
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

  void setUsers(List<UserProfileInfo>? users) {
    _users = users ?? [];
    notifyListeners();
  }
}
