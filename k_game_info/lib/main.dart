import 'package:flutter/material.dart';
import 'package:k_game_info/data/constants.dart';
import 'package:k_game_info/models/game_main_page.dart';
import 'package:k_game_info/widget_assets/game_tile.dart';
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
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  String prevSearch = "";

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
    if(!isSearch){
      GameApi().getGamesMainPage(offset: games == null ? 0 : games!.length)
        .then((value){
          setState((){
            if(games == null) { games = value.cast<GameMainPage>(); }
            else { games!.addAll(value.cast<GameMainPage>()); }
          });
          reloadingProcess = false;
        });
    }
    else{
      GameApi().searchGames(searchFor: prevSearch, offset: games == null ? 0 : games!.length)
        .then((value){
          setState((){
            if(games == null) { games = value.cast<GameMainPage>(); }
            else { games!.addAll(value.cast<GameMainPage>()); }
          });
          reloadingProcess = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          title: const Text("KGameInfo"),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: games == null ? const Text("Loading") :
                ListView.builder(
                  controller: scrollController,
                  itemCount: games!.length,
                  itemBuilder: (context, index) =>
                    GameTile(game: games![index]),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      late List<GameMainPage> newGames;
                      if(searchController.text.isEmpty) { 
                        newGames = await GameApi().getGamesMainPage();
                      }
                      else {
                        newGames = await GameApi().searchGames(searchFor: searchController.text);
                      }

                      setState((){
                        games = newGames;
                        scrollController.jumpTo(0);
                      });
                    }, 
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
            ),
          ]
        )
      ),
    );
  }
}
