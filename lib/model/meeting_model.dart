part of "models.dart";

class MeetingModel{
  String id;
  String meetingName;
  String meetingURL;
  String description;
  List<String> attendees;
  DateTime meetingStartTime;
  DateTime meetingEndTime;
  DateTime timestamp;
  bool? isPinned;
  String? sender;

  MeetingModel({
    required this.id,
    required this.meetingName,
    required this.meetingURL,
    required this.description,
    required this.attendees,
    required this.meetingStartTime,
    required this.meetingEndTime,
    required this.timestamp,
    this.sender,
    this.isPinned
  });
}