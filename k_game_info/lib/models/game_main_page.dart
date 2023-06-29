class GameMainPage {
  final int id;
  final String name;
  final int? firstReleaseDate;
  final String? cover;
  final double rating;

  GameMainPage({required this.id, required this.name, this.firstReleaseDate, 
                this.cover, required this.rating});
  
  static GameMainPage jsonParse(dynamic json){
    try{
      var id = json['id'];
      var name = json['name'];
      var firstReleaseDate =  json.containsKey('first_release_date') ? 
        json['first_release_date'] : null;
      var cover = json.containsKey('cover') ? 
        json['cover'] : null;
      var rating = json.containsKey('rating') ? 
        json['rating'] : 0.0;
        
      return GameMainPage(id: id, name: name, firstReleaseDate: firstReleaseDate, 
                          cover: cover, rating: rating);
    }
    catch(err){
      throw("Incorrect json format: ${err.toString()}");
    }
  }

  String? get firstReleaseDateString {
    if(firstReleaseDate == null) return null;
    var date =  DateTime.fromMillisecondsSinceEpoch(firstReleaseDate! * 1000);
    return "${date.year}-${date.month}-${date.day}";
  }
}