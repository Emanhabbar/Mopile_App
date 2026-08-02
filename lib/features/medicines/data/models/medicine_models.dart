class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantityInStock,
    required this.requiresPrescription,
    this.scientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.composition,
    this.description,
  });

  final String id;
  final String name;
  final String? scientificName;
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

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    scientificName: _nullable(json['scientificName']),
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
  );
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
    this.scientificName,
    this.manufacturer,
    this.dosageForm,
    this.packageSize,
    this.capacity,
    this.composition,
    this.description,
  });

  final String name;
  final String? scientificName;
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
    'scientificName': _clean(scientificName),
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
