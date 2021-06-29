part of "models.dart";

enum ServiceStatus{ paid, unpaid, cancelled }

class ServiceModel{
  String serviceName;
  ServiceStatus status;
  String description;
  List<MilestoneModel>? milestones;
  int? serviceFee;

  ServiceModel({
    this.milestones,
    this.serviceFee,
    required this.serviceName,
    required this.status,
    required this.description,
  });
}