part of 'models.dart';

class MilestoneModel{
  String id;
  String milestoneName;
  String description;
  bool isCompleted;
  int? fee;
  ProjectPaymentStatus paymentStatus;
  ProjectStatus status;
  DateTime? dueDate;

  MilestoneModel({
    this.fee,
    this.dueDate,
    required this.id,
    required this.paymentStatus,
    required this.status,
    required this.milestoneName,
    required this.description,
    required this.isCompleted
  });
}