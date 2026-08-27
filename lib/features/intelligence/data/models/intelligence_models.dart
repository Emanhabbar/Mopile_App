class AlternativeMedicine {
  const AlternativeMedicine({
    required this.medicineName,
    required this.matchScore,
    required this.reason,
    this.composition,
    this.form,
    this.size,
    this.manufacturer,
    this.sellingPrice,
  });

  factory AlternativeMedicine.fromJson(Map<String, dynamic> json) =>
      AlternativeMedicine(
        medicineName: json['medicineName']?.toString() ?? '',
        composition: _optional(json['composition']),
        form: _optional(json['form']),
        size: _optional(json['size']),
        manufacturer: _optional(json['manufacturer']),
        sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
        matchScore: (json['matchScore'] as num?)?.toDouble() ?? 0,
        reason: json['reason']?.toString() ?? '',
      );

  final String medicineName;
  final String? composition;
  final String? form;
  final String? size;
  final String? manufacturer;
  final double? sellingPrice;
  final double matchScore;
  final String reason;
}

class AlternativeMedicineResult {
  const AlternativeMedicineResult({
    required this.status,
    required this.alternatives,
    this.searchedMedicine,
    this.composition,
  });

  factory AlternativeMedicineResult.fromJson(Map<String, dynamic> json) =>
      AlternativeMedicineResult(
        status: json['status']?.toString() ?? '',
        searchedMedicine: _optional(json['searchedMedicine']),
        composition: _optional(json['composition']),
        alternatives: (json['alternatives'] as List? ?? const [])
            .whereType<Map>()
            .map(
              (item) =>
                  AlternativeMedicine.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList(growable: false),
      );

  final String status;
  final String? searchedMedicine;
  final String? composition;
  final List<AlternativeMedicine> alternatives;
}

class StockoutPrediction {
  const StockoutPrediction({
    required this.daysUntilStockout,
    required this.riskLevel,
    required this.recommendedReorderQuantity,
  });

  factory StockoutPrediction.fromJson(Map<String, dynamic> json) =>
      StockoutPrediction(
        daysUntilStockout: (json['daysUntilStockout'] as num?)?.toDouble() ?? 0,
        riskLevel: json['riskLevel']?.toString() ?? '',
        recommendedReorderQuantity:
            (json['recommendedReorderQuantity'] as num?)?.toInt() ?? 0,
      );

  final double daysUntilStockout;
  final String riskLevel;
  final int recommendedReorderQuantity;
}

class IntelligenceHealth {
  const IntelligenceHealth({
    required this.status,
    required this.medicinesCount,
    required this.model,
  });

  factory IntelligenceHealth.fromJson(Map<String, dynamic> json) =>
      IntelligenceHealth(
        status: json['status']?.toString() ?? '',
        medicinesCount: (json['medicinesCount'] as num?)?.toInt() ?? 0,
        model: json['model']?.toString() ?? '',
      );

  final String status;
  final int medicinesCount;
  final String model;
}

String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}
