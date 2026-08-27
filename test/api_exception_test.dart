import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/core/errors/api_exception.dart';

void main() {
  group('ApiException location classification', () {
    test('recognizes the localized missing-location error', () {
      const error = ApiException(
        'حدد موقعك أولًا لعرض الصيدليات القريبة.',
        statusCode: 400,
      );

      expect(error.isLocationRequired, isTrue);
    });

    test('does not classify unrelated API failures as location errors', () {
      const error = ApiException('تعذر الاتصال بالخادم.', statusCode: 503);

      expect(error.isLocationRequired, isFalse);
    });
  });
}
