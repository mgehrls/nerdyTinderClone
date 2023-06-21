import 'package:fantascan/models/user_model.dart';
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
          child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(child: buildCards()),
                ],
              )),
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

    return Stack(
      children: userCards,
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.clear, color: Colors.red, size: 32),
        ),
        ElevatedButton(
            onPressed: () {},
            child: const Icon(Icons.star, color: Colors.blue, size: 32)),
        ElevatedButton(
            onPressed: () {},
            child: const Icon(Icons.favorite, color: Colors.teal, size: 32))
      ],
    );
  }

  Widget buildLogo() {
    return Row(
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
