import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/pharmacy/data/models/pharmacy_models.dart';
import 'package:pharmacy_app/features/pharmacy/presentation/widgets/batch_inventory_editor.dart';

void main() {
  testWidgets('batch editor tracks a different price for every medicine', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BatchInventoryEditor(
            medicines: [
              PharmacyCatalogMedicine(
                id: 'medicine-1',
                name: 'باراسيتامول',
                requiresPrescription: false,
              ),
              PharmacyCatalogMedicine(
                id: 'medicine-2',
                name: 'أموكسيسيلين',
                requiresPrescription: true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('0/2 أسعار'), findsOneWidget);
    final firstPrice = find.byKey(const ValueKey('batch-price-medicine-1'));
    final secondPrice = find.byKey(const ValueKey('batch-price-medicine-2'));

    await tester.enterText(firstPrice, '8500');
    await tester.pump();
    expect(find.text('1/2 أسعار'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(secondPrice, findsOneWidget);
    await tester.enterText(secondPrice, '16000');
    await tester.pump();
    expect(find.text('2/2 أسعار'), findsOneWidget);
  });
}
