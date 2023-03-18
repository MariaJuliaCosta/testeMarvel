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
