part of "models.dart";

class HandlesModel{
  String id;
  String name;
  String description;
  List<String> members;
  String cover;
  List<String>? pinnedBy;
  List<String>? messages; //TODO: MESSAGES MODEL

  HandlesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.cover,
    this.pinnedBy,
    this.messages
  });
}