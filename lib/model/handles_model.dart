part of "models.dart";

class HandlesModel{
  String id;
  String name;
  String description;
  Map<String, String> members;
  String cover;
  List<String>? pinnedBy;
  List<String>? archivedBy;
  List<ChatModel>? messages;

  HandlesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.cover,
    this.archivedBy,
    this.pinnedBy,
    this.messages
  });
}