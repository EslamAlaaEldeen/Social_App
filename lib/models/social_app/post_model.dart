class PostModel {
  String? name;
  String? uId;
  String? image;
  String? datetime;
  String? text;
  String? postImage;

  PostModel(
      {this.name,
      this.uId,
      this.image,
      this.datetime,
      this.text,
      this.postImage});
  PostModel.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    datetime = json['datetime'];
    text = json['text'];
    postImage = json['postImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'datetime': datetime,
      'text': text,
      'postImage': postImage,
    };
  }
}
