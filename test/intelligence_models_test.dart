import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/features/intelligence/data/models/intelligence_models.dart';

void main() {
  group('Intelligence API models', () {
    test('parses medicine alternatives', () {
      final result = AlternativeMedicineResult.fromJson({
        'status': 'ok',
        'searchedMedicine': 'دواء أصلي',
        'alternatives': [
          {
            'medicineName': 'دواء بديل',
            'composition': 'Paracetamol',
            'matchScore': 0.92,
            'reason': 'تركيب مشابه',
          },
        ],
      });

      expect(result.alternatives.single.medicineName, 'دواء بديل');
      expect(result.alternatives.single.matchScore, 0.92);
    });

    test('parses stockout prediction', () {
      final result = StockoutPrediction.fromJson({
        'daysUntilStockout': 4.5,
        'riskLevel': 'High',
        'recommendedReorderQuantity': 30,
      });

      expect(result.daysUntilStockout, 4.5);
      expect(result.recommendedReorderQuantity, 30);
    });
  });
}
