class HomeTickerItem {
  const HomeTickerItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isActive,
    required this.sortOrder,
    this.pharmacyProfileId,
    this.pharmacyName,
    this.startsAtUtc,
    this.endsAtUtc,
  });

  factory HomeTickerItem.fromJson(Map<String, dynamic> json) => HomeTickerItem(
    id: json['id']?.toString() ?? '',
    type: json['type']?.toString() ?? 'Announcement',
    title: json['title']?.toString() ?? '',
    message: json['message']?.toString() ?? '',
    pharmacyProfileId: _optional(json['pharmacyProfileId']),
    pharmacyName: _optional(json['pharmacyName']),
    isActive: json['isActive'] == true,
    sortOrder: json['sortOrder'] is num
        ? (json['sortOrder'] as num).toInt()
        : int.tryParse('${json['sortOrder']}') ?? 0,
    startsAtUtc: DateTime.tryParse(json['startsAtUtc']?.toString() ?? ''),
    endsAtUtc: DateTime.tryParse(json['endsAtUtc']?.toString() ?? ''),
  );

  final String id;
  final String type;
  final String title;
  final String message;
  final String? pharmacyProfileId;
  final String? pharmacyName;
  final bool isActive;
  final int sortOrder;
  final DateTime? startsAtUtc;
  final DateTime? endsAtUtc;

  bool get isDutyPharmacy => type.toLowerCase() == 'dutypharmacy';
}

String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
