part of "models.dart";

enum ChatType{status, plain, image, video, docs, voice, meets, project}

class ChatModel{
  String id;
  String sender;
  String? content;
  String? mediaURL;
  bool isPinned;
  ChatType type;
  DateTime timestamp;
  List<String> deletedBy;
  List<String> readBy;

  ChatModel({
    required this.id,
    required this.sender,
    required this.isPinned,
    this.content,
    this.mediaURL,
    required this.type,
    required this.timestamp,
    required this.deletedBy,
    required this.readBy
  });
}