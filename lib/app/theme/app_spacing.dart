/// مقياس المسافات والأبعاد الموّحد المستخدم في الصفحات الرئيسية وبطاقاتها،
/// لضمان إيقاع رأسي ثابت ومظهر متطابق بين جميع الأدوار.
abstract final class AppSpace {
  static const double xxs = 6;
  static const double xs = 10;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
}

/// مقياس أنصاف الأقطار الموّحد.
abstract final class AppRadius {
  static const double xs = 14;
  static const double sm = 20;
  static const double tile = 21;
  static const double card = 24;
  static const double hero = 30;
}

/// الأبعاد الموحدة لمربعات الأيقونات داخل البطاقات.
abstract final class AppIconBox {
  static const double tile = 42;
  static const double badge = 46;
  static const double hero = 62;
}
