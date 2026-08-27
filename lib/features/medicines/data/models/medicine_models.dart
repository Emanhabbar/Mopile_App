class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantityInStock,
    required this.requiresPrescription,
    this.barcode,
    this.arabicName,
    String? displayName,
    this.scientificName,
    this.arabicScientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.composition,
    this.description,
    this.aliases = const [],
  }) : displayName = displayName ?? arabicName ?? name;

  final String id;
  final String name;
  final String? barcode;
  final String? arabicName;
  final String displayName;
  final String? scientificName;
  final String? arabicScientificName;
  final double purchasePrice;
  final double sellingPrice;
  final int quantityInStock;
  final String? manufacturer;
  final String? dosageForm;
  final String? packageSize;
  final String? capacity;
  final String? composition;
  final String? description;
  final bool requiresPrescription;
  final List<MedicineAlias> aliases;

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    barcode: _nullable(json['barcode']),
    arabicName: _nullable(json['arabicName']),
    displayName: _nullable(json['displayName']),
    scientificName: _nullable(json['scientificName']),
    arabicScientificName: _nullable(json['arabicScientificName']),
    purchasePrice: _double(json['purchasePrice']),
    sellingPrice: _double(json['sellingPrice']),
    quantityInStock: _int(json['quantityInStock']),
    manufacturer: _nullable(json['manufacturer']),
    dosageForm: _nullable(json['dosageForm']),
    packageSize: _nullable(json['packageSize']),
    capacity: _nullable(json['capacity']),
    composition: _nullable(json['composition']),
    description: _nullable(json['description']),
    requiresPrescription: json['requiresPrescription'] as bool? ?? false,
    aliases: json['aliases'] is List
        ? (json['aliases'] as List)
              .whereType<Map>()
              .map(
                (item) =>
                    MedicineAlias.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(growable: false)
        : const [],
  );
}

class MedicineAlias {
  const MedicineAlias({
    required this.id,
    required this.value,
    required this.language,
    required this.aliasType,
    required this.source,
    required this.isVerified,
  });

  factory MedicineAlias.fromJson(Map<String, dynamic> json) => MedicineAlias(
    id: json['id']?.toString() ?? '',
    value: json['value']?.toString() ?? '',
    language: json['language']?.toString() ?? '',
    aliasType: json['aliasType']?.toString() ?? '',
    source: json['source']?.toString() ?? '',
    isVerified: json['isVerified'] as bool? ?? false,
  );

  final String id;
  final String value;
  final String language;
  final String aliasType;
  final String source;
  final bool isVerified;
}

class MedicinePage {
  const MedicinePage({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  final List<Medicine> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  bool get hasPreviousPage => pageNumber > 1;
  bool get hasNextPage => pageNumber < totalPages;

  factory MedicinePage.fromJson(Map<String, dynamic> json) => MedicinePage(
    items: json['items'] is List
        ? (json['items'] as List)
              .whereType<Map>()
              .map((item) => Medicine.fromJson(Map<String, dynamic>.from(item)))
              .toList(growable: false)
        : const [],
    pageNumber: _int(json['pageNumber']),
    pageSize: _int(json['pageSize']),
    totalCount: _int(json['totalCount']),
    totalPages: _int(json['totalPages']),
  );
}

class CreateMedicine {
  const CreateMedicine({
    required this.name,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantityInStock,
    required this.requiresPrescription,
    this.barcode,
    this.arabicName,
    this.scientificName,
    this.arabicScientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.composition,
    this.description,
  });

  final String name;
  final String? barcode;
  final String? arabicName;
  final String? scientificName;
  final String? arabicScientificName;
  final double purchasePrice;
  final double sellingPrice;
  final int quantityInStock;
  final String? manufacturer;
  final String? dosageForm;
  final String? packageSize;
  final String? capacity;
  final String? composition;
  final String? description;
  final bool requiresPrescription;

  Map<String, dynamic> toJson() => {
    'name': name.trim(),
    'barcode': _clean(barcode),
    'arabicName': _clean(arabicName),
    'scientificName': _clean(scientificName),
    'arabicScientificName': _clean(arabicScientificName),
    'purchasePrice': purchasePrice,
    'sellingPrice': sellingPrice,
    'quantityInStock': quantityInStock,
    'manufacturer': _clean(manufacturer),
    'dosageForm': _clean(dosageForm),
    'packageSize': _clean(packageSize),
    'capacity': _clean(capacity),
    'composition': _clean(composition),
    'description': _clean(description),
    'requiresPrescription': requiresPrescription,
  };
}

class MedicineAliasInput {
  const MedicineAliasInput({
    required this.value,
    this.language = 'ar',
    this.aliasType = 'Common',
  });

  final String value;
  final String language;
  final String aliasType;

  Map<String, dynamic> toJson() => {
    'value': value.trim(),
    'language': language,
    'aliasType': aliasType,
  };
}

class UpdateMedicineLocalization {
  const UpdateMedicineLocalization({
    this.arabicName,
    this.arabicScientificName,
    this.aliases = const [],
  });

  final String? arabicName;
  final String? arabicScientificName;
  final List<MedicineAliasInput> aliases;

  Map<String, dynamic> toJson() => {
    'arabicName': _clean(arabicName),
    'arabicScientificName': _clean(arabicScientificName),
    'aliases': aliases.map((item) => item.toJson()).toList(growable: false),
  };
}

String? _nullable(Object? value) => _clean(value?.toString());

String? _clean(String? value) {
  final result = value?.trim();
  return result == null || result.isEmpty ? null : result;
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

double _double(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? 0;
