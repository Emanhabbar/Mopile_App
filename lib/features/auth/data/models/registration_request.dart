import '../../../../core/network/api_endpoints.dart';

enum RegistrationType {
  user,
  pharmacy,
  organization,
  warehouse;

  String get endpoint => switch (this) {
    RegistrationType.user => ApiEndpoints.authRegisterUser,
    RegistrationType.pharmacy => ApiEndpoints.authRegisterPharmacy,
    RegistrationType.organization => ApiEndpoints.authRegisterOrganization,
    RegistrationType.warehouse => ApiEndpoints.authRegisterWarehouse,
  };
}

class RegistrationRequest {
  const RegistrationRequest({
    required this.type,
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phoneNumber,
    this.entityName,
    this.registrationNumber,
    this.city,
    this.area,
    this.address,
    this.description,
    this.hasDeliveryService = false,
    this.latitude,
    this.longitude,
    this.minimumOrderAmount = 0,
    this.deliveryFee = 0,
  });

  final RegistrationType type;
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phoneNumber;
  final String? entityName;
  final String? registrationNumber;
  final String? city;
  final String? area;
  final String? address;
  final String? description;
  final bool hasDeliveryService;
  final double? latitude;
  final double? longitude;
  final double minimumOrderAmount;
  final double deliveryFee;

  Map<String, dynamic> toJson() {
    final common = <String, dynamic>{
      'fullName': fullName.trim(),
      'email': email.trim(),
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': _nullableText(phoneNumber),
    };

    if (type == RegistrationType.user) return common;

    final business = <String, dynamic>{
      ...common,
      'city': city!.trim(),
      'area': area!.trim(),
      'address': address!.trim(),
      'description': _nullableText(description),
    };

    if (type == RegistrationType.pharmacy) {
      return {
        ...business,
        'pharmacyName': entityName!.trim(),
        'licenseNumber': registrationNumber!.trim(),
        'hasDeliveryService': hasDeliveryService,
        'latitude': latitude,
        'longitude': longitude,
      };
    }

    if (type == RegistrationType.organization) {
      return {
        ...business,
        'organizationName': entityName!.trim(),
        'registrationNumber': registrationNumber!.trim(),
      };
    }

    return {
      ...business,
      'warehouseName': entityName!.trim(),
      'licenseNumber': registrationNumber!.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'minimumOrderAmount': minimumOrderAmount,
      'deliveryFee': deliveryFee,
    };
  }

  static String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
