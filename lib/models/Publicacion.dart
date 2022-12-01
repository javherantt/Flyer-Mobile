class Publicacion {
  int id;
  int userId;
  int tagId;
  String title;
  String description;
  String filename;
  int views;
  DateTime timestap;

  Publicacion(
      id, userId, tagId, title, description, filename, views, timestamp) {
    this.id = id;
    this.userId = userId;
    this.tagId = tagId;
    this.title = title;
    this.description = description;
    this.filename = filename;
    this.views = views;
    this.timestap = timestap;
  }
}
