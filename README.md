# دوائي — تطبيق Flutter

تطبيق الجوال لمنصة دوائي. يستخدم نفس ASP.NET Core API التي يستخدمها
تطبيق الويب، مع فصل العنوان حسب بيئة التشغيل.

## التشغيل

تأكد أولًا أن Backend يعمل، ثم استخدم الأمر المناسب:

### Android Emulator

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5030/api/
```

### Windows أو متصفح على الجهاز نفسه

```powershell
flutter run -d windows --dart-define=API_BASE_URL=http://localhost:5030/api/
```

### هاتف حقيقي على الشبكة المحلية

استبدل العنوان بعنوان IPv4 الخاص بجهاز تشغيل Backend:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5030/api/
```

لا تستخدم عناوين التطوير في نسخة الإنتاج. استخدم رابط HTTPS منشورًا:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api/
```

## الهيكل

- `lib/app`: تشغيل التطبيق، التوجيه، الثيم واللغة.
- `lib/core`: الشبكة، الأخطاء، الإعدادات والتخزين الآمن.
- `lib/features`: كل ميزة مع طبقات البيانات والعرض الخاصة بها.
- `lib/shared`: النماذج والمكونات المشتركة.
- `lib/l10n`: نصوص العربية والإنجليزية.

الشرح التفصيلي لمسار التنفيذ ومسؤولية كل طبقة موجود في
[`docs/ARCHITECTURE_AR.md`](docs/ARCHITECTURE_AR.md).

## فحوصات الجودة

```powershell
flutter pub get
flutter gen-l10n
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

## ضوابط مهمة

- لا تضع مفاتيح Google أو AI داخل تطبيق Flutter.
- JWT محفوظ في التخزين الآمن للنظام.
- عنوان API يمر عبر `--dart-define` ولا يكتب داخل الصفحات.
- السماح باتصالات HTTP محصور في Android Debug؛ الإنتاج يجب أن يستخدم HTTPS.
- ملفات لوحات الهوية داخل `assets/brand` مراجع تصميم، ولا تُضمّن في التطبيق إلا
  الأصول المعلنة صراحة في `pubspec.yaml`.
