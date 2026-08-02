class PrescriptionOrder {
  const PrescriptionOrder({
    required this.id,
    required this.status,
    required this.originalFileName,
    required this.matchPercentage,
    required this.warnings,
    required this.items,
    required this.pharmacyMatches,
    required this.doseRemindersEnabled,
    required this.refillReminderEnabled,
    required this.createdAtUtc,
    this.pharmacyId,
    this.pharmacyName,
    this.reservedUntilUtc,
    this.qrPayload,
  });

  factory PrescriptionOrder.fromJson(Map<String, dynamic> json) {
    return PrescriptionOrder(
      id: _text(json['id']),
      status: _text(json['status']),
      originalFileName: _text(json['originalFileName']),
      pharmacyId: _nullableText(json['pharmacyId']),
      pharmacyName: _nullableText(json['pharmacyName']),
      matchPercentage: _decimal(json['matchPercentage']),
      reservedUntilUtc: _date(json['reservedUntilUtc']),
      qrPayload: _nullableText(json['qrPayload']),
      warnings: _stringList(json['warnings']),
      items: _objectList(json['items'], PrescriptionItem.fromJson),
      pharmacyMatches: _objectList(
        json['pharmacyMatches'],
        PrescriptionPharmacyMatch.fromJson,
      ),
      doseRemindersEnabled: json['doseRemindersEnabled'] == true,
      refillReminderEnabled: json['refillReminderEnabled'] == true,
      createdAtUtc: _date(json['createdAtUtc']) ?? DateTime.now().toUtc(),
    );
  }

  final String id;
  final String status;
  final String originalFileName;
  final String? pharmacyId;
  final String? pharmacyName;
  final double matchPercentage;
  final DateTime? reservedUntilUtc;
  final String? qrPayload;
  final List<String> warnings;
  final List<PrescriptionItem> items;
  final List<PrescriptionPharmacyMatch> pharmacyMatches;
  final bool doseRemindersEnabled;
  final bool refillReminderEnabled;
  final DateTime createdAtUtc;

  bool get isAnalyzed => status.toLowerCase() == 'analyzed';
  bool get isReserved => status.toLowerCase() == 'reserved';
  bool get isReadyForPickup => status.toLowerCase() == 'readyforpickup';
  bool get isCollected => status.toLowerCase() == 'collected';
  bool get isClosed =>
      status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'expired';
  bool get canCancel => !isClosed && !isCollected;
  bool get canActivateReminders => isCollected;
  String? get pickupCode {
    final uri = qrPayload == null ? null : Uri.tryParse(qrPayload!);
    return uri?.queryParameters['code'];
  }
}

class PrescriptionItem {
  const PrescriptionItem({
    required this.id,
    required this.extractedName,
    required this.requestedQuantity,
    required this.reservedQuantity,
    required this.extractionConfidence,
    this.medicineId,
    this.matchedMedicineName,
    this.scientificName,
    this.strength,
    this.dosageInstructions,
  });

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      id: _text(json['id']),
      medicineId: _nullableText(json['medicineId']),
      extractedName: _text(json['extractedName']),
      matchedMedicineName: _nullableText(json['matchedMedicineName']),
      scientificName: _nullableText(json['scientificName']),
      strength: _nullableText(json['strength']),
      dosageInstructions: _nullableText(json['dosageInstructions']),
      requestedQuantity: _integer(json['requestedQuantity']),
      reservedQuantity: _integer(json['reservedQuantity']),
      extractionConfidence: _decimal(json['extractionConfidence']),
    );
  }

  final String id;
  final String? medicineId;
  final String extractedName;
  final String? matchedMedicineName;
  final String? scientificName;
  final String? strength;
  final String? dosageInstructions;
  final int requestedQuantity;
  final int reservedQuantity;
  final double extractionConfidence;

  String get displayName => matchedMedicineName?.trim().isNotEmpty == true
      ? matchedMedicineName!
      : extractedName;
  bool get isMatched => medicineId != null;
}

class PrescriptionPharmacyMatch {
  const PrescriptionPharmacyMatch({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.address,
    required this.availableItems,
    required this.totalItems,
    required this.matchPercentage,
    required this.hasCompletePrescription,
    this.distanceMeters,
  });

  factory PrescriptionPharmacyMatch.fromJson(Map<String, dynamic> json) {
    return PrescriptionPharmacyMatch(
      pharmacyId: _text(json['pharmacyId']),
      pharmacyName: _text(json['pharmacyName']),
      address: _text(json['address']),
      distanceMeters: json['distanceMeters'] == null
          ? null
          : _decimal(json['distanceMeters']),
      availableItems: _integer(json['availableItems']),
      totalItems: _integer(json['totalItems']),
      matchPercentage: _decimal(json['matchPercentage']),
      hasCompletePrescription: json['hasCompletePrescription'] == true,
    );
  }

  final String pharmacyId;
  final String pharmacyName;
  final String address;
  final double? distanceMeters;
  final int availableItems;
  final int totalItems;
  final double matchPercentage;
  final bool hasCompletePrescription;
}

class PrescriptionReminderRequest {
  const PrescriptionReminderRequest({
    required this.doseRemindersEnabled,
    required this.refillReminderEnabled,
    required this.reminderTime,
    required this.durationDays,
    required this.refillAfterDays,
  });

  final bool doseRemindersEnabled;
  final bool refillReminderEnabled;
  final String reminderTime;
  final int durationDays;
  final int refillAfterDays;

  Map<String, dynamic> toJson() => {
    'doseRemindersEnabled': doseRemindersEnabled,
    'refillReminderEnabled': refillReminderEnabled,
    'reminderTime': reminderTime,
    'durationDays': durationDays,
    'refillAfterDays': refillAfterDays,
  };
}

List<T> _objectList<T>(Object? value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => parser(Map<String, dynamic>.from(item)))
      .toList(growable: false);
}

List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Object>()
      .map((item) => item.toString())
      .toList(growable: false);
}

String _text(Object? value) => value?.toString() ?? '';
String? _nullableText(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _integer(Object? value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
double _decimal(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
DateTime? _date(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());
