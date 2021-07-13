part of "models.dart";

enum ProjectPaymentStatus{ paid, unpaid }
enum ProjectStatus{ pending, in_progress, completed, cancelled}

class ProjectModel{
  String id;
  String serviceName;
  ProjectPaymentStatus paymentStatus;
  ProjectStatus status;
  String description;
  List<MilestoneModel>? milestones;
  bool? isPinned;
  DateTime timestamp;
  String? sender;

  ProjectModel({
    this.sender,
    this.isPinned,
    this.milestones,
    required this.timestamp,
    required this.id,
    required this.status,
    required this.serviceName,
    required this.paymentStatus,
    required this.description,
  });
}