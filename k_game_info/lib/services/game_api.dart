import 'dart:convert';

import '../data//client_credentials.dart' as client_data;
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

  //get 10 games by a query
  Future<dynamic> getGames(BodyQuery bodyQuery) async {
    var response = await http.post(
      Uri.https(
        'api.igdb.com', 
        'v4/games',
      ),
      headers: {
        "Client-ID": client_data.id,
        "Authorization": "Bearer 2dr9rde2ezx5d38r6vd6s84rdebvb5"
      },
      body: bodyQuery.toString()
    );
    return jsonDecode(response.body);
  }
}

class BodyQuery {
  //fields *; sort rating desc; where rating != null & rating_count > 100;
  List<String>? _fields;
  List<String>? _where;
  List<String>? _sort;

  BodyQuery({List<String>? fields, List<String>? where, List<String>? sort}){
    _fields = fields;
    _where = where;
    _sort = sort;
  }

  @override
  String toString() {
    String queryString = "fields ";
    
    //adding field query to queryString
    if(_fields == null) { queryString += '*'; }
    else { queryString += _fields!.join(","); }
    queryString += ";";
    
    //adding where options to queryString
    if(_where != null){
      queryString += " where ";
      queryString += _where!.join(" & ");
      queryString += ";";
    }

    //adding sort options to queryString
    if(_sort != null){
      for(var sort in _sort!){
        queryString += " sort $sort;";
      }
    }

    return queryString;
  }
}