import 'dart:convert';
import '../models/game_main_page.dart';
import 'body_query.dart';

import '../data/client_credentials.dart' as client_data;
import 'package:http/http.dart' as http;

class GameApi {
  late String _accessToken;
  
  //code which makes this class a singleton
  static final GameApi _gameApi = GameApi._();
  factory GameApi() => _gameApi;
  GameApi._();

  //method for receiving or updating access token
  Future fetchAccessToken() async {
    // var response = await http.post(
    //   Uri.https(
    //     'id.twitch.tv', 
    //     'oauth2/token',
    //     {
    //       'client_id': client_data.id,
    //       'client_secret': client_data.pass,
    //       'grant_type': 'client_credentials'
    //     }
    //   )
    // );
    // _accessToken = jsonDecode(response.body)["access_token"];

    //for now there is a constant token
    _accessToken = "2dr9rde2ezx5d38r6vd6s84rdebvb5";
  }

  //get json encoded response from given endpoint and given body
  Future<List<dynamic>> getResponse(String endpoint, BodyQuery bodyQuery) async {
    var response = await http.post(
      Uri.https(
        'api.igdb.com', 
        'v4/$endpoint',
      ),
      headers: {
        "Client-ID": client_data.id,
        "Authorization": "Bearer $_accessToken"
      },
      body: bodyQuery.toString()
    );
    return jsonDecode(response.body);
  }

  //main page game query
  Future<List<GameMainPage>> getGamesMainPage({int offset = 0}) async {

    //get first 10 games with biggest rating and rated by more than 100 users
    var jsonGames = await GameApi().getResponse("games",
      BodyQuery(
        fields: [ "name", "first_release_date", "cover" ],
        where: [ "rating != null", "rating_count > 100" ],
        sort: [ "rating desc" ],
        offset: offset
      )
    );

    List<String> imageIdList = jsonGames.map<String>((g) => "id = ${g["cover"]}").toList();
    
    //get image_id which match id of these games
    var jsonImages = await GameApi().getResponse("covers",
      BodyQuery(
        fields: [ "image_id" ],
        where: imageIdList,
        whereSeparator: "|"
      )
    );

    //set jsonGame record cover to an image_id
    for(var entry in jsonGames){
      entry["cover"] = jsonImages.firstWhere((el) => el["id"] == entry["cover"])["image_id"];
    }

    return jsonGames.map((e) => GameMainPage.jsonParse(e)).toList();
  }
}