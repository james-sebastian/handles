part of "models.dart";

class UserModel{
  String id;
  String name;
  String countryCode;
  String phoneNumber;
  String? profilePicture;
  String? role;
  String? company;
  String? companyAddress;
  String? companyLogo;
  String? creditCard;
  List<String>? handlesList;

  UserModel({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.phoneNumber,
    required this.profilePicture,
    this.companyLogo,
    this.role,
    this.company,
    this.companyAddress,
    this.creditCard,
    this.handlesList,
  });
}