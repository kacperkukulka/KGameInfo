import 'package:flutter/material.dart';
import 'package:k_game_info/models/game_main_page.dart';

import '../data/constants.dart';

class GameTile extends StatelessWidget {
  const GameTile({super.key, required this.game});

  final GameMainPage game;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(top: 15, right: 10, left: 10),
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                width: 130,
                height: double.infinity,
                child: Image.network(
                  "$coverBig${game.cover}.jpg", 
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              )
            ),
            const SizedBox(width: 10,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name, 
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    "Release date: ${game.firstReleaseDateString??"unknown"}", 
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Expanded(child: SizedBox(),),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Rating: ${game.rating.toStringAsFixed(2)}", 
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}