class DataMarvel {
  DataMarvel({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  int offset;
  int limit;
  int total;
  int count;
  List<CharactersMarvel> results;

  factory DataMarvel.fromJson(Map<String, dynamic> json) => DataMarvel(
        offset: json["offset"],
        limit: json["limit"],
        total: json["total"],
        count: json["count"],
        results: List<CharactersMarvel>.from(
            json["results"].map((x) => CharactersMarvel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "limit": limit,
        "total": total,
        "count": count,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class CharactersMarvel {
  CharactersMarvel({
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  String name;
  String description;
  Thumbnail thumbnail;

  factory CharactersMarvel.fromJson(Map<String, dynamic> json) =>
      CharactersMarvel(
        name: json["name"],
        description: json["description"],
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "thumbnail": thumbnail.toJson(),
      };
}

class Thumbnail {
  Thumbnail({
    required this.path,
    required this.extension,
  });

  String path;
  String extension;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        path: json["path"],
        extension: json["extension"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "extension": extension,
      };
}
