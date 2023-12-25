class MessageModel {
  String? text;
  String? datetime;
  String? senderId;
  String? receiverId;

  MessageModel({
    this.text,
    this.datetime,
    this.senderId,
    this.receiverId,
  });
  MessageModel.fromjson(Map<String, dynamic> json) {
    text = json['text'];
    datetime = json['datetime'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'datetime': datetime,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }
}
