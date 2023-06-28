class BodyQuery {
  List<String>? _fields;
  List<String>? _where;
  List<String>? _sort;
  String? _whereSeparator;
  int? _offset;

  BodyQuery({List<String>? fields, List<String>? where, 
    List<String>? sort, String? whereSeparator, int? offset}){
    _fields = fields;
    _where = where;
    _sort = sort;
    _whereSeparator = whereSeparator;
    _offset = offset;
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
      queryString += _where!.join(" ${_whereSeparator??'&'} ");
      queryString += ";";
    }

    //adding sort options to queryString
    if(_sort != null){
      for(var sort in _sort!){
        queryString += " sort $sort;";
      }
    }

    //adding offset to queryString
    if(_offset != null) queryString += " offset $_offset;";

    return queryString;
  }
}