import 'package:flutter/material.dart';
import 'services/game_api.dart';

void main() async {
  await GameApi().fetchAccessToken();
  var json = await GameApi().getGames(
    BodyQuery(
      where: [
        "rating != null",
        "rating_count > 100"
      ],
      sort: [
        "rating desc"
      ]
    )
  );

  for(var jsonObj in json){
    print(jsonObj);
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
