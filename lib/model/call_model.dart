part of "models.dart";

class CallModel{
  List<String> intendedParticipants;
  List<String> participants;
  DateTime? startTime;
  DateTime? endTime;

  CallModel({required this.intendedParticipants, required this.participants, this.startTime, this.endTime});
}