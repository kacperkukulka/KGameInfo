class GameMainPage {
  final int id;
  final String name;
  final int? firstReleaseDate;
  final String? cover;

  GameMainPage({required this.id, required this.name, this.firstReleaseDate, this.cover});
  
  static GameMainPage jsonParse(dynamic json){
    try{
      var id = json['id'];
      var name = json['name'];
      var firstReleaseDate =  json.containsKey('first_release_date') ? 
        json['first_release_date'] : null;
      var cover = json.containsKey('cover') ? 
        json['cover'] : null;
        
      return GameMainPage(id: id, name: name, firstReleaseDate: firstReleaseDate, cover: cover);
    }
    catch(err){
      throw("Incorrect json format: ${err.toString()}");
    }
  }
}