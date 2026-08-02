class SupplyDashboard {
  const SupplyDashboard({
    required this.activeBatches,
    required this.lowStockBatches,
    required this.expiringBatches,
    required this.pendingOrders,
    required this.activeDeliveries,
    required this.inventoryValue,
    required this.recentOrders,
    required this.alerts,
  });
  factory SupplyDashboard.fromJson(Map<String, dynamic> json) =>
      SupplyDashboard(
        activeBatches: _int(json['activeBatches']),
        lowStockBatches: _int(json['lowStockBatches']),
        expiringBatches: _int(json['expiringBatches']),
        pendingOrders: _int(json['pendingOrders']),
        activeDeliveries: _int(json['activeDeliveries']),
        inventoryValue: _double(json['inventoryValue']),
        recentOrders: _list(json['recentOrders'], SupplyOrder.fromJson),
        alerts: _list(json['alerts'], MedicineBatch.fromJson),
      );
  final int activeBatches,
      lowStockBatches,
      expiringBatches,
      pendingOrders,
      activeDeliveries;
  final double inventoryValue;
  final List<SupplyOrder> recentOrders;
  final List<MedicineBatch> alerts;
}

class MedicineBatch {
  const MedicineBatch({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.batchNumber,
    required this.quantityAvailable,
    required this.quantityReserved,
    required this.sellableQuantity,
    required this.wholesalePrice,
    required this.expiryDateUtc,
    required this.isActive,
    required this.health,
    this.storageLocation,
  });
  factory MedicineBatch.fromJson(Map<String, dynamic> json) => MedicineBatch(
    id: _text(json['id']),
    medicineId: _text(json['medicineId']),
    medicineName: _text(json['medicineName']),
    batchNumber: _text(json['batchNumber']),
    quantityAvailable: _int(json['quantityAvailable']),
    quantityReserved: _int(json['quantityReserved']),
    sellableQuantity: _int(json['sellableQuantity']),
    wholesalePrice: _double(json['wholesalePrice']),
    expiryDateUtc: _date(json['expiryDateUtc']),
    storageLocation: _optional(json['storageLocation']),
    isActive: json['isActive'] == true,
    health: _text(json['health']),
  );
  final String id, medicineId, medicineName, batchNumber, health;
  final int quantityAvailable, quantityReserved, sellableQuantity;
  final double wholesalePrice;
  final DateTime expiryDateUtc;
  final String? storageLocation;
  final bool isActive;
}

class WarehouseMarketplace {
  const WarehouseMarketplace({
    required this.id,
    required this.name,
    required this.city,
    required this.area,
    required this.address,
    required this.minimumOrderAmount,
    required this.deliveryFee,
    required this.availableMedicines,
    this.distanceKm,
  });
  factory WarehouseMarketplace.fromJson(Map<String, dynamic> json) =>
      WarehouseMarketplace(
        id: _text(json['id']),
        name: _text(json['name']),
        city: _text(json['city']),
        area: _text(json['area']),
        address: _text(json['address']),
        minimumOrderAmount: _double(json['minimumOrderAmount']),
        deliveryFee: _double(json['deliveryFee']),
        availableMedicines: _int(json['availableMedicines']),
        distanceKm: _nullableDouble(json['distanceKm']),
      );
  final String id, name, city, area, address;
  final double minimumOrderAmount, deliveryFee;
  final int availableMedicines;
  final double? distanceKm;
}

class WarehouseCatalogItem {
  const WarehouseCatalogItem({
    required this.medicineId,
    required this.medicineName,
    required this.availableQuantity,
    required this.bestPrice,
    required this.nearestExpiry,
    this.scientificName,
  });
  factory WarehouseCatalogItem.fromJson(Map<String, dynamic> json) =>
      WarehouseCatalogItem(
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        scientificName: _optional(json['scientificName']),
        availableQuantity: _int(json['availableQuantity']),
        bestPrice: _double(json['bestPrice']),
        nearestExpiry: _date(json['nearestExpiry']),
      );
  final String medicineId, medicineName;
  final String? scientificName;
  final int availableQuantity;
  final double bestPrice;
  final DateTime nearestExpiry;
}

class SupplyOrderItem {
  const SupplyOrderItem({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.requestedQuantity,
    required this.approvedQuantity,
    required this.deliveredQuantity,
    required this.unitPrice,
    this.batchNumber,
  });
  factory SupplyOrderItem.fromJson(Map<String, dynamic> json) =>
      SupplyOrderItem(
        id: _text(json['id']),
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        batchNumber: _optional(json['batchNumber']),
        requestedQuantity: _int(json['requestedQuantity']),
        approvedQuantity: _int(json['approvedQuantity']),
        deliveredQuantity: _int(json['deliveredQuantity']),
        unitPrice: _double(json['unitPrice']),
      );
  final String id, medicineId, medicineName;
  final String? batchNumber;
  final int requestedQuantity, approvedQuantity, deliveredQuantity;
  final double unitPrice;
}

class Shipment {
  const Shipment({
    required this.id,
    required this.shipmentCode,
    required this.status,
    required this.pickupQrToken,
    this.representativeProfileId,
    this.representativeName,
    this.dispatchedAtUtc,
    this.deliveredAtUtc,
    this.tracking = const [],
  });
  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
    id: _text(json['id']),
    shipmentCode: _text(json['shipmentCode']),
    status: _text(json['status']),
    representativeProfileId: _optional(json['representativeProfileId']),
    representativeName: _optional(json['representativeName']),
    pickupQrToken: _text(json['pickupQrToken']),
    dispatchedAtUtc: _optionalDate(json['dispatchedAtUtc']),
    deliveredAtUtc: _optionalDate(json['deliveredAtUtc']),
    tracking: _list(json['tracking'], TrackingEvent.fromJson),
  );
  final String id, shipmentCode, status, pickupQrToken;
  final String? representativeProfileId, representativeName;
  final DateTime? dispatchedAtUtc, deliveredAtUtc;
  final List<TrackingEvent> tracking;
}

class TrackingEvent {
  const TrackingEvent({
    required this.status,
    required this.occurredAtUtc,
    this.note,
    this.latitude,
    this.longitude,
  });
  factory TrackingEvent.fromJson(Map<String, dynamic> json) => TrackingEvent(
    status: _text(json['status']),
    note: _optional(json['note']),
    latitude: _nullableDouble(json['latitude']),
    longitude: _nullableDouble(json['longitude']),
    occurredAtUtc: _date(json['occurredAtUtc']),
  );
  final String status;
  final String? note;
  final double? latitude, longitude;
  final DateTime occurredAtUtc;
}

class SupplyOrder {
  const SupplyOrder({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.pharmacyName,
    required this.warehouseName,
    required this.pharmacyCity,
    required this.pharmacyArea,
    required this.pharmacyAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.createdAtUtc,
    required this.items,
    this.pharmacyPhoneNumber,
    this.pharmacyLatitude,
    this.pharmacyLongitude,
    this.shipment,
    this.invoice,
  });
  factory SupplyOrder.fromJson(Map<String, dynamic> json) => SupplyOrder(
    id: _text(json['id']),
    orderCode: _text(json['orderCode']),
    status: _text(json['status']),
    pharmacyName: _text(json['pharmacyName']),
    warehouseName: _text(json['warehouseName']),
    pharmacyPhoneNumber: _optional(json['pharmacyPhoneNumber']),
    pharmacyCity: _text(json['pharmacyCity']),
    pharmacyArea: _text(json['pharmacyArea']),
    pharmacyAddress: _text(json['pharmacyAddress']),
    pharmacyLatitude: _nullableDouble(json['pharmacyLatitude']),
    pharmacyLongitude: _nullableDouble(json['pharmacyLongitude']),
    subtotal: _double(json['subtotal']),
    deliveryFee: _double(json['deliveryFee']),
    totalAmount: _double(json['totalAmount']),
    createdAtUtc: _date(json['createdAtUtc']),
    items: _list(json['items'], SupplyOrderItem.fromJson),
    shipment: json['shipment'] is Map
        ? Shipment.fromJson(Map<String, dynamic>.from(json['shipment'] as Map))
        : null,
    invoice: json['invoice'] is Map
        ? SupplyInvoice.fromJson(
            Map<String, dynamic>.from(json['invoice'] as Map),
          )
        : null,
  );
  final String id,
      orderCode,
      status,
      pharmacyName,
      warehouseName,
      pharmacyCity,
      pharmacyArea,
      pharmacyAddress;
  final String? pharmacyPhoneNumber;
  final double? pharmacyLatitude, pharmacyLongitude;
  final double subtotal, deliveryFee, totalAmount;
  final DateTime createdAtUtc;
  final List<SupplyOrderItem> items;
  final Shipment? shipment;
  final SupplyInvoice? invoice;
}

class Representative {
  const Representative({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.employeeCode,
    required this.isEnabled,
    required this.accountIsActive,
    required this.isAvailable,
    required this.isOnShift,
    required this.activeDeliveries,
    required this.completedDeliveries,
    this.vehiclePlateNumber,
    this.workingDays = const [],
    this.shiftStart,
    this.shiftEnd,
    this.availabilityNote,
  });
  factory Representative.fromJson(Map<String, dynamic> json) => Representative(
    id: _text(json['id']),
    userId: _text(json['userId']),
    fullName: _text(json['fullName']),
    email: _text(json['email']),
    employeeCode: _text(json['employeeCode']),
    vehiclePlateNumber: _optional(json['vehiclePlateNumber']),
    isEnabled: json['isEnabled'] == true,
    accountIsActive: json['accountIsActive'] == true,
    isAvailable: json['isAvailable'] == true,
    isOnShift: json['isOnShift'] == true,
    activeDeliveries: _int(json['activeDeliveries']),
    completedDeliveries: _int(json['completedDeliveries']),
    workingDays: (json['workingDays'] as List? ?? const [])
        .whereType<num>()
        .map((value) => value.toInt())
        .toList(growable: false),
    shiftStart: _optional(json['shiftStart']),
    shiftEnd: _optional(json['shiftEnd']),
    availabilityNote: _optional(json['availabilityNote']),
  );
  final String id, userId, fullName, email, employeeCode;
  final String? vehiclePlateNumber;
  final bool isEnabled, accountIsActive, isAvailable, isOnShift;
  final int activeDeliveries, completedDeliveries;
  final List<int> workingDays;
  final String? shiftStart, shiftEnd, availabilityNote;
}

class SupplyInvoice {
  const SupplyInvoice({
    required this.id,
    required this.orderId,
    required this.invoiceNumber,
    required this.orderCode,
    required this.pharmacyName,
    required this.warehouseName,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.issuedAtUtc,
    required this.dueAtUtc,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    this.paidAtUtc,
    this.warehouseNote,
    this.payments = const [],
  });
  factory SupplyInvoice.fromJson(Map<String, dynamic> json) => SupplyInvoice(
    id: _text(json['id']),
    orderId: _text(json['orderId']),
    invoiceNumber: _text(json['invoiceNumber']),
    orderCode: _text(json['orderCode']),
    pharmacyName: _text(json['pharmacyName']),
    warehouseName: _text(json['warehouseName']),
    status: _text(json['status']),
    paymentStatus: _text(json['paymentStatus']),
    paymentMethod: _text(json['paymentMethod']),
    totalAmount: _double(json['totalAmount']),
    paidAmount: _double(json['paidAmount']),
    remainingAmount: _double(json['remainingAmount']),
    issuedAtUtc: _date(json['issuedAtUtc']),
    dueAtUtc: _date(json['dueAtUtc']),
    subtotal: _double(json['subtotal']),
    deliveryFee: _double(json['deliveryFee']),
    discountAmount: _double(json['discountAmount']),
    taxAmount: _double(json['taxAmount']),
    paidAtUtc: _optionalDate(json['paidAtUtc']),
    warehouseNote: _optional(json['warehouseNote']),
    payments: _list(json['payments'], SupplyPayment.fromJson),
  );
  final String id,
      orderId,
      invoiceNumber,
      orderCode,
      pharmacyName,
      warehouseName,
      status,
      paymentStatus,
      paymentMethod;
  final double totalAmount, paidAmount, remainingAmount;
  final double subtotal, deliveryFee, discountAmount, taxAmount;
  final DateTime issuedAtUtc, dueAtUtc;
  final DateTime? paidAtUtc;
  final String? warehouseNote;
  final List<SupplyPayment> payments;
}

class SupplyPayment {
  const SupplyPayment({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.paidAtUtc,
    this.referenceNumber,
    this.note,
  });
  factory SupplyPayment.fromJson(Map<String, dynamic> json) => SupplyPayment(
    id: _text(json['id']),
    amount: _double(json['amount']),
    method: _text(json['method']),
    status: _text(json['status']),
    referenceNumber: _optional(json['referenceNumber']),
    note: _optional(json['note']),
    paidAtUtc: _date(json['paidAtUtc']),
  );
  final String id, method, status;
  final double amount;
  final String? referenceNumber, note;
  final DateTime paidAtUtc;
}

class SupplyReturn {
  const SupplyReturn({
    required this.id,
    required this.orderCode,
    required this.medicineName,
    required this.quantity,
    required this.reason,
    required this.status,
    required this.createdAtUtc,
    this.reviewNote,
  });
  factory SupplyReturn.fromJson(Map<String, dynamic> json) => SupplyReturn(
    id: _text(json['id']),
    orderCode: _text(json['orderCode']),
    medicineName: _text(json['medicineName']),
    quantity: _int(json['quantity']),
    reason: _text(json['reason']),
    status: _text(json['status']),
    reviewNote: _optional(json['reviewNote']),
    createdAtUtc: _date(json['createdAtUtc']),
  );
  final String id, orderCode, medicineName, reason, status;
  final int quantity;
  final String? reviewNote;
  final DateTime createdAtUtc;
}

class MedicineRecall {
  const MedicineRecall({
    required this.id,
    required this.batchId,
    required this.batchNumber,
    required this.medicineName,
    required this.reason,
    required this.severity,
    required this.status,
    required this.initiatedAtUtc,
  });
  factory MedicineRecall.fromJson(Map<String, dynamic> json) => MedicineRecall(
    id: _text(json['id']),
    batchId: _text(json['batchId']),
    batchNumber: _text(json['batchNumber']),
    medicineName: _text(json['medicineName']),
    reason: _text(json['reason']),
    severity: _text(json['severity']),
    status: _text(json['status']),
    initiatedAtUtc: _date(json['initiatedAtUtc']),
  );
  final String id, batchId, batchNumber, medicineName, reason, severity, status;
  final DateTime initiatedAtUtc;
}

class RestockSuggestion {
  const RestockSuggestion({
    required this.medicineId,
    required this.medicineName,
    required this.currentQuantity,
    required this.lowStockThreshold,
    required this.suggestedQuantity,
    this.recommendedWarehouseId,
    this.recommendedWarehouseName,
    this.bestPrice,
  });
  factory RestockSuggestion.fromJson(Map<String, dynamic> json) =>
      RestockSuggestion(
        medicineId: _text(json['medicineId']),
        medicineName: _text(json['medicineName']),
        currentQuantity: _int(json['currentQuantity']),
        lowStockThreshold: _int(json['lowStockThreshold']),
        suggestedQuantity: _int(json['suggestedQuantity']),
        recommendedWarehouseId: _optional(json['recommendedWarehouseId']),
        recommendedWarehouseName: _optional(json['recommendedWarehouseName']),
        bestPrice: _nullableDouble(json['bestPrice']),
      );
  final String medicineId, medicineName;
  final int currentQuantity, lowStockThreshold, suggestedQuantity;
  final String? recommendedWarehouseId, recommendedWarehouseName;
  final double? bestPrice;
}

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) parser) =>
    value is List
    ? value
          .whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false)
    : const [];
String _text(Object? value) => value?.toString() ?? '';
String? _optional(Object? value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty ? null : text;
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
double _double(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
double? _nullableDouble(Object? value) => value == null ? null : _double(value);
DateTime _date(Object? value) =>
    DateTime.tryParse('$value') ?? DateTime.now().toUtc();
DateTime? _optionalDate(Object? value) =>
    value == null ? null : DateTime.tryParse('$value');
