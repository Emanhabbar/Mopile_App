# دوائي — تطبيق Flutter

تطبيق الجوال لمنصة **دوائي**، ويستخدم نفس ASP.NET Core API التي يستخدمها تطبيق الويب، مع فصل عنوان الـ API حسب بيئة التشغيل.

## التشغيل

تأكد أولًا من تشغيل الـ Backend، ثم استخدم الأمر المناسب حسب بيئة التشغيل.

### Android Emulator

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5030/api/
```

### Windows أو المتصفح على الجهاز نفسه

```powershell
flutter run -d windows --dart-define=API_BASE_URL=http://localhost:5030/api/
```

### هاتف حقيقي على الشبكة المحلية

استبدل العنوان بعنوان IPv4 الخاص بالجهاز الذي يعمل عليه الـ Backend:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5030/api/
```

> لا تستخدم عناوين التطوير في نسخة الإنتاج. استخدم رابط HTTPS منشورًا.

### Production

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com/api/
```

## هيكل المشروع

* `lib/app`: تشغيل التطبيق، التوجيه، الثيم واللغة.
* `lib/core`: الشبكة، الأخطاء، الإعدادات والتخزين الآمن.
* `lib/features`: كل ميزة مع طبقات البيانات والعرض الخاصة بها.
* `lib/shared`: النماذج والمكونات المشتركة.
* `lib/l10n`: نصوص العربية والإنجليزية.
* `docs`: توثيق بنية المشروع ومسؤوليات الطبقات.

الشرح التفصيلي لمسار التنفيذ ومسؤولية كل طبقة موجود في:

`docs/ARCHITECTURE_AR.md`

## فحوصات الجودة

قبل رفع التغييرات أو إنشاء نسخة جديدة، يمكن تنفيذ:

```powershell
flutter pub get

flutter gen-l10n

dart format --output=none --set-exit-if-changed lib test

flutter analyze

flutter test

flutter build apk --debug
```

## ضوابط مهمة

* لا تضع مفاتيح Google أو AI داخل تطبيق Flutter.
* يتم حفظ JWT في التخزين الآمن للنظام.
* عنوان API يمر عبر `--dart-define` ولا يتم كتابته داخل صفحات التطبيق.
* السماح باتصالات HTTP محصور في Android Debug.
* يجب استخدام HTTPS في بيئة الإنتاج.
* ملفات لوحات الهوية داخل `assets/brand` هي مراجع تصميم، ولا تُضمّن في التطبيق إلا الأصول المعلنة صراحةً في `pubspec.yaml`.

## Git

المشروع يحتوي على عدة فروع للتطوير والدمج. يجب التأكد من الفرع الحالي قبل تنفيذ عمليات `merge` أو `push`.

يمكن التحقق باستخدام:

```powershell
git status
git branch
```
