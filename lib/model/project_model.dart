part of "models.dart";

enum ProjectPaymentStatus{ paid, unpaid }
enum ProjectStatus{ pending, in_progress, completed, cancelled}

class ServiceModel{
  String serviceName;
  ProjectPaymentStatus paymentStatus;
  ProjectStatus status;
  String description;
  List<MilestoneModel>? milestones;

  ServiceModel({
    this.milestones,
    required this.status,
    required this.serviceName,
    required this.paymentStatus,
    required this.description,
  });
}