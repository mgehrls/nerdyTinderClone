import 'dart:math';
import 'package:fantascan/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class UserCard extends StatefulWidget {
  final UserProfileInfo user;
  final bool isFront;

  const UserCard({Key? key, required this.user, required this.isFront})
      : super(key: key);
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(widget.user.uid));

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 300;

          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: Stack(children: [
                buildCard(widget.user.uid),
                buildStamps(),
              ]));
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition(details);
        },
      );

  Widget buildName(String name, String age) => Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            age,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget buildStatus() => Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            width: 12,
            height: 12,
          ),
          const SizedBox(width: 8),
          const Text(
            "Recently Active",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.interested:
        final child = buildStamp(
          angle: -.5,
          color: Colors.green,
          text: "LIKE",
          opacity: opacity,
        );
        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.notInterested:
        final child = buildStamp(
          angle: .5,
          color: Colors.red,
          text: "NOPE",
          opacity: opacity,
        );
        return Positioned(top: 64, right: 50, child: child);
      case CardStatus.favorited:
        final child = buildStamp(
          angle: 0,
          color: Colors.blue,
          text: "FAVED :)",
          opacity: opacity,
        );
        return Positioned(bottom: 100, left: 0, right: 0, child: child);
      case CardStatus.blocked:
        final child = buildStamp(
          angle: 0,
          color: Colors.black,
          text: "BLOCKED :(",
          opacity: opacity,
        );
        return Positioned(top: 100, left: 0, right: 0, child: child);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildStamp({
    required double angle,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 4)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String uid) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Colors.grey,
              Colors.blueGrey,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            image: DecorationImage(
              image: NetworkImage(widget.user.profilePictureUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  buildName(widget.user.name, widget.user.age.toString()),
                  const SizedBox(height: 8),
                  buildStatus(),
                ],
              ),
            ),
          ),
        ));
  }
}
