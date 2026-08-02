import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/supply_chain/data/models/supply_chain_models.dart';

void main() {
  group('Supply chain API models', () {
    test('parses warehouse dashboard and nested alerts', () {
      final dashboard = SupplyDashboard.fromJson({
        'activeBatches': 12,
        'lowStockBatches': 2,
        'expiringBatches': 1,
        'pendingOrders': 3,
        'activeDeliveries': 4,
        'inventoryValue': 250000,
        'recentOrders': const [],
        'alerts': [
          {
            'id': 'batch-1',
            'medicineId': 'medicine-1',
            'medicineName': 'دواء',
            'batchNumber': 'B-1',
            'quantityAvailable': 10,
            'quantityReserved': 2,
            'sellableQuantity': 8,
            'wholesalePrice': 1200,
            'expiryDateUtc': '2027-08-01T00:00:00Z',
            'isActive': true,
            'health': 'LowStock',
          },
        ],
      });

      expect(dashboard.pendingOrders, 3);
      expect(dashboard.inventoryValue, 250000);
      expect(dashboard.alerts.single.sellableQuantity, 8);
    });

    test('parses an order with shipment tracking and invoice payments', () {
      final order = SupplyOrder.fromJson({
        'id': 'order-1',
        'orderCode': 'SO-1',
        'status': 'OutForDelivery',
        'pharmacyName': 'صيدلية الشفاء',
        'warehouseName': 'مستودع دوائي',
        'pharmacyCity': 'دمشق',
        'pharmacyArea': 'المزة',
        'pharmacyAddress': 'الشارع الرئيسي',
        'subtotal': 5000,
        'deliveryFee': 500,
        'totalAmount': 5500,
        'createdAtUtc': '2026-08-01T10:00:00Z',
        'items': const [],
        'shipment': {
          'id': 'shipment-1',
          'shipmentCode': 'SH-1',
          'status': 'OutForDelivery',
          'pickupQrToken': 'token',
          'tracking': [
            {
              'status': 'OutForDelivery',
              'occurredAtUtc': '2026-08-01T11:00:00Z',
            },
          ],
        },
        'invoice': {
          'id': 'invoice-1',
          'orderId': 'order-1',
          'invoiceNumber': 'INV-1',
          'orderCode': 'SO-1',
          'pharmacyName': 'صيدلية الشفاء',
          'warehouseName': 'مستودع دوائي',
          'status': 'PartiallyPaid',
          'paymentStatus': 'PartiallyPaid',
          'paymentMethod': 'CashOnDelivery',
          'totalAmount': 5500,
          'paidAmount': 2000,
          'remainingAmount': 3500,
          'issuedAtUtc': '2026-08-01T10:00:00Z',
          'dueAtUtc': '2026-08-10T10:00:00Z',
          'payments': [
            {
              'id': 'payment-1',
              'amount': 2000,
              'method': 'CashOnDelivery',
              'status': 'Paid',
              'paidAtUtc': '2026-08-01T12:00:00Z',
            },
          ],
        },
      });

      expect(order.shipment?.tracking.single.status, 'OutForDelivery');
      expect(order.invoice?.payments.single.amount, 2000);
      expect(order.invoice?.remainingAmount, 3500);
    });
  });
}
