import 'package:fantascan/components/header.dart';
import 'package:fantascan/providers/card_provider.dart';
import 'package:fantascan/providers/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/user_card.dart';
import '../providers/app_state_provider.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext context;

  const HomeScreen({super.key, required this.title, required this.context});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String screen = "home";

  @override
  Widget build(BuildContext context) {
    AppStateProvider appStateProvider = Provider.of<AppStateProvider>(context);
    screen = appStateProvider.screen;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.teal,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(8.0), child: buildHomeScreen()),
        ),
      ),
    );
  }

  Widget buildHomeScreen() {
    return Column(
      children: [
        buildHeader(context),
        const SizedBox(height: 8),
        Expanded(child: buildCards()),
        const SizedBox(height: 8),
        buildButtons(),
      ],
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final List<UserCard> userCards = users
        .map((user) => UserCard(
              user: user,
              isFront: user == users.last,
            ))
        .toList();

    if (userCards.isEmpty) {
      return Center(
          child: ElevatedButton(
        onPressed: () {
          getUsers();
        },
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Reset',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
    } else {
      return Stack(
        children: userCards,
      );
    }
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: getColor(Colors.red, Colors.white, false),
              backgroundColor: getColor(Colors.white, Colors.red, false),
              side: getBorder(Colors.red, Colors.red, false),
            ),
            onPressed: () {
              provider.notInterested();
            },
            child: const Icon(Icons.clear, color: Colors.red, size: 32),
          ),
          ElevatedButton(
              style: ButtonStyle(
                foregroundColor: getColor(Colors.blue, Colors.white, false),
                backgroundColor: getColor(Colors.white, Colors.blue, false),
                side: getBorder(Colors.blue, Colors.blue, false),
              ),
              onPressed: () {
                provider.favorite();
              },
              child: const Icon(Icons.star, color: Colors.blue, size: 32)),
          ElevatedButton(
              style: ButtonStyle(
                foregroundColor: getColor(Colors.teal, Colors.white, false),
                backgroundColor: getColor(Colors.white, Colors.teal, false),
                side: getBorder(Colors.teal, Colors.teal, false),
              ),
              onPressed: () {
                provider.like();
              },
              child: const Icon(Icons.favorite, color: Colors.teal, size: 32))
        ],
      ),
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool forced) {
    getColor(Set<MaterialState> states) {
      if (forced || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, forced) {
    getBorder(Set<MaterialState> states) {
      if (forced || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    return MaterialStateProperty.resolveWith(getBorder);
  }

  void getUsers() async {
    final db = Provider.of<DbProvider>(context, listen: false);
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    cardProvider.setUsers(await db.getUsers());
  }
}
