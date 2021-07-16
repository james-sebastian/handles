part of "models.dart";

enum ChatType{status, plain, image, video, docs, voice, meets, project}

class ChatModel{
  String? content;
  String? mediaURL;
  String id;
  String sender;
  String replyTo;
  bool isPinned;
  ChatType type;
  DateTime timestamp;
  List<String> deletedBy;
  List<String> readBy;

  ChatModel({
    this.content,
    this.mediaURL,
    required this.id,
    required this.sender,
    required this.replyTo,
    required this.isPinned,
    required this.type,
    required this.timestamp,
    required this.deletedBy,
    required this.readBy
  });
}