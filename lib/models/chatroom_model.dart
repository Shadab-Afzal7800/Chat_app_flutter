class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? createdon;
  List<dynamic>? users;
  ChatRoomModel({
    this.chatroomid,
    this.participants,
    this.lastMessage,
    this.createdon,
    this.users,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    users = map["users"];
    try {
      createdon = DateTime.parse(map["createdon"] as String);
    } catch (e) {
      return;
    }
  }
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastMessage": lastMessage,
      "createdon": createdon,
      "users": users
    };
  }
}
