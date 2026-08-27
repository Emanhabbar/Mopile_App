import 'package:dio/dio.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/supply_chain_models.dart';

class SupplyChainRemoteDataSource {
  const SupplyChainRemoteDataSource(this._dio);
  final Dio _dio;

  Future<SupplyDashboard> dashboard() async => SupplyDashboard.fromJson(
    await _get(ApiEndpoints.supplyWarehouseDashboard),
  );
  Future<List<MedicineBatch>> batches([String? query]) => _getList(
    ApiEndpoints.supplyWarehouseBatches,
    MedicineBatch.fromJson,
    query: {if (query?.trim().isNotEmpty == true) 'query': query!.trim()},
  );
  Future<MedicineBatch> saveBatch({
    String? id,
    required String medicineId,
    required String batchNumber,
    required int quantity,
    required double purchasePrice,
    required double wholesalePrice,
    required DateTime expiryDate,
    String? storageLocation,
  }) async {
    final body = {
      'medicineId': medicineId,
      'batchNumber': batchNumber,
      'quantityAvailable': quantity,
      'purchasePrice': purchasePrice,
      'wholesalePrice': wholesalePrice,
      'expiryDateUtc': expiryDate.toUtc().toIso8601String(),
      'storageLocation': storageLocation,
    };
    return MedicineBatch.fromJson(
      id == null
          ? await _post(ApiEndpoints.supplyWarehouseBatches, body)
          : await _put(ApiEndpoints.supplyBatch(id), body),
    );
  }

  Future<List<WarehouseMarketplace>> marketplace([String? query]) => _getList(
    ApiEndpoints.supplyMarketplace,
    WarehouseMarketplace.fromJson,
    query: {if (query?.trim().isNotEmpty == true) 'query': query!.trim()},
  );
  Future<List<WarehouseCatalogItem>> catalog(String id, [String? query]) =>
      _getList(
        ApiEndpoints.supplyWarehouseCatalog(id),
        WarehouseCatalogItem.fromJson,
        query: {if (query?.trim().isNotEmpty == true) 'query': query!.trim()},
      );
  Future<SupplyOrder> createOrder(
    String warehouseId,
    Map<String, int> quantities, {
    String? note,
  }) async => SupplyOrder.fromJson(
    await _post(ApiEndpoints.supplyOrders, {
      'warehouseProfileId': warehouseId,
      'items': quantities.entries
          .map((e) => {'medicineId': e.key, 'quantity': e.value})
          .toList(),
      'note': note,
    }),
  );
  Future<List<SupplyOrder>> orders() =>
      _getList(ApiEndpoints.supplyOrders, SupplyOrder.fromJson);
  Future<SupplyOrder> updateOrderStatus(
    String id,
    String status, {
    String? note,
  }) async => SupplyOrder.fromJson(
    await _put(ApiEndpoints.supplyOrderStatus(id), {
      'status': status,
      'note': note,
    }),
  );
  Future<SupplyOrder> assignShipment(
    String orderId,
    String representativeId, {
    int packageCount = 1,
  }) async => SupplyOrder.fromJson(
    await _post(ApiEndpoints.supplyAssignShipment(orderId), {
      'representativeProfileId': representativeId,
      'packageCount': packageCount,
    }),
  );
  Future<List<Representative>> representatives() =>
      _getList(ApiEndpoints.supplyRepresentatives, Representative.fromJson);
  Future<Representative> createRepresentative({
    required String fullName,
    required String email,
    required String password,
    required String employeeCode,
    String? vehiclePlateNumber,
  }) async => Representative.fromJson(
    await _post(ApiEndpoints.supplyRepresentatives, {
      'fullName': fullName,
      'email': email,
      'password': password,
      'employeeCode': employeeCode,
      'vehiclePlateNumber': vehiclePlateNumber,
    }),
  );
  Future<Representative> updateRepresentative(
    Representative representative, {
    bool? isEnabled,
    bool? isAvailable,
  }) async => Representative.fromJson(
    await _put(ApiEndpoints.supplyRepresentative(representative.id), {
      'fullName': representative.fullName,
      'employeeCode': representative.employeeCode,
      'vehiclePlateNumber': representative.vehiclePlateNumber,
      'isEnabled': isEnabled ?? representative.isEnabled,
      'isAvailable': isAvailable ?? representative.isAvailable,
      'workingDays': representative.workingDays,
      'shiftStart': representative.shiftStart,
      'shiftEnd': representative.shiftEnd,
      'availabilityNote': representative.availabilityNote,
    }),
  );
  Future<List<SupplyInvoice>> invoices([String? status]) => _getList(
    ApiEndpoints.supplyInvoices,
    SupplyInvoice.fromJson,
    query: {if (status?.isNotEmpty == true) 'status': status},
  );
  Future<SupplyInvoice> invoice(String id) async =>
      SupplyInvoice.fromJson(await _get(ApiEndpoints.supplyInvoice(id)));
  Future<SupplyInvoice> updateInvoice(
    String id, {
    required String paymentMethod,
    required DateTime dueAtUtc,
    double discountAmount = 0,
    double taxAmount = 0,
    String? note,
  }) async => SupplyInvoice.fromJson(
    await _put(ApiEndpoints.supplyWarehouseInvoice(id), {
      'paymentMethod': paymentMethod,
      'dueAtUtc': dueAtUtc.toUtc().toIso8601String(),
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'warehouseNote': note,
    }),
  );
  Future<SupplyInvoice> recordPayment(
    String id, {
    required double amount,
    required String method,
    String? reference,
    String? note,
  }) async => SupplyInvoice.fromJson(
    await _post(ApiEndpoints.supplyInvoicePayments(id), {
      'amount': amount,
      'method': method,
      'referenceNumber': reference,
      'note': note,
    }),
  );
  Future<List<SupplyReturn>> returns() =>
      _getList(ApiEndpoints.supplyReturns, SupplyReturn.fromJson);
  Future<SupplyReturn> reviewReturn(
    String id,
    String status, {
    String? note,
  }) async => SupplyReturn.fromJson(
    await _put(ApiEndpoints.supplyReviewReturn(id), {
      'status': status,
      'note': note,
    }),
  );
  Future<List<MedicineRecall>> recalls() =>
      _getList(ApiEndpoints.supplyRecalls, MedicineRecall.fromJson);
  Future<MedicineRecall> createRecall(
    String batchId,
    String reason,
    String severity,
  ) async => MedicineRecall.fromJson(
    await _post(ApiEndpoints.supplyCreateRecall, {
      'medicineBatchId': batchId,
      'reason': reason,
      'severity': severity,
    }),
  );
  Future<List<RestockSuggestion>> suggestions() => _getList(
    ApiEndpoints.supplyRestockSuggestions,
    RestockSuggestion.fromJson,
  );
  Future<SupplyOrder> updateShipment(
    String id,
    String status, {
    String? note,
    double? latitude,
    double? longitude,
  }) async => SupplyOrder.fromJson(
    await _put(ApiEndpoints.supplyRepresentativeShipment(id), {
      'status': status,
      'note': note,
      'latitude': latitude,
      'longitude': longitude,
    }),
  );
  Future<SupplyOrder> confirmDelivery(
    String shipmentId,
    String qrToken, {
    String? note,
  }) async => SupplyOrder.fromJson(
    await _post(ApiEndpoints.supplyConfirmShipment(shipmentId), {
      'qrToken': qrToken,
      'proofNote': note,
    }),
  );
  Future<SupplyReturn> createReturn(
    String orderId,
    String orderItemId,
    int quantity,
    String reason,
  ) async => SupplyReturn.fromJson(
    await _post(ApiEndpoints.supplyCreateReturn(orderId), {
      'orderItemId': orderItemId,
      'quantity': quantity,
      'reason': reason,
    }),
  );

  Future<Map<String, dynamic>> _get(String path) async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(path);
      return r.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) parser, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final r = await _dio.get<List<dynamic>>(path, queryParameters: query);
      return (r.data ?? const [])
          .whereType<Map>()
          .map((e) => parser(Map<String, dynamic>.from(e)))
          .toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final r = await _dio.post<Map<String, dynamic>>(path, data: body);
      return r.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final r = await _dio.put<Map<String, dynamic>>(path, data: body);
      return r.data ?? const {};
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
