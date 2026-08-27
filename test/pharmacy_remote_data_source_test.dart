import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/pharmacy/data/data_sources/pharmacy_remote_data_source.dart';
import 'package:pharmacy_app/features/pharmacy/data/models/pharmacy_models.dart';
import 'package:pharmacy_app/features/pharmacy/data/repositories/pharmacy_repository.dart';

void main() {
  test('catalog search unwraps the paged backend response', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost/api/'))
      ..httpClientAdapter = _JsonAdapter({
        'items': [
          {
            'id': 'medicine-1',
            'name': 'Panadol',
            'scientificName': 'Paracetamol',
            'manufacturer': 'Test manufacturer',
            'dosageForm': 'Tablet',
            'capacity': '500 mg',
            'requiresPrescription': false,
          },
        ],
        'pageNumber': 1,
        'pageSize': 50,
        'totalCount': 1,
        'totalPages': 1,
      });

    final page = await PharmacyRemoteDataSource(dio).searchCatalog('');

    expect(page.items, hasLength(1));
    expect(page.items.single.id, 'medicine-1');
    expect(page.items.single.name, 'Panadol');
    expect(page.hasNextPage, isFalse);
  });

  test(
    'batch inventory keeps an independent price for every medicine',
    () async {
      final adapter = _JsonAdapter([
        {'inventoryItemId': 'inventory-1', 'medicineId': 'medicine-1'},
        {'inventoryItemId': 'inventory-2', 'medicineId': 'medicine-2'},
      ]);
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost/api/'))
        ..httpClientAdapter = adapter;

      await PharmacyRemoteDataSource(dio).addInventoryBatch(
        items: const [
          PharmacyInventoryBatchItemInput(
            medicineId: 'medicine-1',
            quantity: 20,
            unitPrice: 8500,
            isPriceVisibleToUsers: true,
            isAvailable: true,
            lowStockThreshold: 5,
          ),
          PharmacyInventoryBatchItemInput(
            medicineId: 'medicine-2',
            quantity: 12,
            unitPrice: 16000,
            isPriceVisibleToUsers: false,
            isAvailable: true,
            lowStockThreshold: 3,
          ),
        ],
      );

      final request = Map<String, dynamic>.from(
        adapter.lastRequest!.data as Map,
      );
      final items = (request['items'] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      expect(items, hasLength(2));
      expect(items[0]['unitPrice'], 8500);
      expect(items[1]['unitPrice'], 16000);
      expect(items[0]['quantity'], 20);
      expect(items[1]['quantity'], 12);
      expect(items[1]['isPriceVisibleToUsers'], isFalse);
    },
  );

  test('catalog repository caches identical pages', () async {
    final adapter = _JsonAdapter({
      'items': [
        {
          'id': 'medicine-1',
          'name': 'Panadol',
          'barcode': '1234567890123',
          'requiresPrescription': false,
        },
      ],
      'pageNumber': 1,
      'pageSize': 30,
      'totalCount': 1,
      'totalPages': 1,
    });
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost/api/'))
      ..httpClientAdapter = adapter;
    final repository = PharmacyRepository(PharmacyRemoteDataSource(dio));

    final first = await repository.searchCatalog('1234567890123');
    final second = await repository.searchCatalog('1234567890123');

    expect(first.items.single.barcode, '1234567890123');
    expect(second.items.single.id, first.items.single.id);
    expect(adapter.requestCount, 1);
  });
}

class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this.payload);

  final Object payload;
  RequestOptions? lastRequest;
  int requestCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    lastRequest = options;
    return ResponseBody.fromString(
      jsonEncode(payload),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
