class MessageModel {
  String? sender;
  String? text;
  String? messageId;
  bool? seen;
  DateTime? createdon;
  MessageModel({
    this.sender,
    this.text,
    this.messageId,
    this.seen,
    this.createdon,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    messageId = map["messageId"];
    try {
      createdon = DateTime.parse(map["createdon"] as String);
    } catch (e) {
      return;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "messageId": messageId
    };
  }
}
