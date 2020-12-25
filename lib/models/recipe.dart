//Model for calling api calls
class Recipe {
  String label;
  String source;
  String url;
  String imgUrl;

  Recipe({this.label, this.source, this.url, this.imgUrl});

  factory Recipe.fromMap(Map<String, dynamic> json) {
    return Recipe(
        imgUrl: json["image"],
        label: json["label"],
        source: json["source"],
        url: json["url"]);
  }
}
