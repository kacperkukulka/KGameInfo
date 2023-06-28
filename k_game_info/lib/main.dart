import 'package:flutter/material.dart';
import 'package:k_game_info/data/constants.dart';
import 'package:k_game_info/models/game_main_page.dart';
import 'services/game_api.dart';

void main() async {
  await GameApi().fetchAccessToken();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ScrollController scrollController;
  List<GameMainPage>? games;
  bool reloadingProcess = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(handleScrolling);
    refreshAnotherRecords();
  }

  Future handleScrolling() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent - 600) {
      refreshAnotherRecords();
    }
  }

  void refreshAnotherRecords(){
    //only one reload at a time
    if(reloadingProcess) return;

    reloadingProcess = true;
    GameApi().getGamesMainPage(offset: games == null ? 0 : games!.length)
      .then((value){
        setState((){
          if(games == null) { games = value.cast<GameMainPage>(); }
          else { games!.addAll(value.cast<GameMainPage>()); }
        });
        reloadingProcess = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("KGameInfo"),
        ),
        body: games == null ? const Text("Loading") :
          ListView.builder(
            controller: scrollController,
            itemCount: games!.length,
            itemBuilder: (context, index) =>
              Image.network("$coverBig${games![index].cover}.jpg",),
          )
      ),
    );
  }
}
