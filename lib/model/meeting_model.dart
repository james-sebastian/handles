part of "models.dart";

class MeetingModel{
  String meetingName;
  String meetingURL;
  String description;
  List<String> attendees;
  DateTime meetingStartTime;
  DateTime meetingEndTime;

  MeetingModel({
    required this.meetingName,
    required this.meetingURL,
    required this.description,
    required this.attendees,
    required this.meetingStartTime,
    required this.meetingEndTime
  });
}