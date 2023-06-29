import 'package:fantascan/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/user_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => CardProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                minimumSize: const Size.square(80),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildLogo(),
                const SizedBox(height: 8),
                Expanded(child: buildCards()),
                const SizedBox(height: 8),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
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
          provider.resetUsers();
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

  Widget buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Icon(Icons.align_horizontal_center_outlined,
            color: Colors.white, size: 32),
        SizedBox(width: 4),
        Text(
          'Fantascan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
