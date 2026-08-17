# آلية الترجمة في تطبيق دوائي (Dawaai)

## 1) البنية الحالية — كيف تعمل الترجمة

التطبيق يستخدم نظام Flutter الرسمي للترجمة (gen-l10n) المبني على ملفات **ARB** وأداة التوليد التلقائي، مع دعم اللغة العربية والإنكليزية.

### البنية في `pubspec.yaml`
```yaml
dependencies:
  flutter_localizations: sdk: flutter   # مطلوبة لتفعيل الترجمة
  intl: 0.20.2                          # مكتبة التنسيقات والترجمة

flutter:
  generate: true                        # يفعّل توليد الكود من ملفات ARB تلقائياً
```

### ملف الإعداد `l10n.yaml`
```yaml
arb-dir: lib/l10n                     # مكان ملفات الترجمة المصدر
template-arb-file: app_ar.arb         # الملف الأساسي (القالب) — هنا العربية
output-arb-file: app_en.arb           # ملف اللغة الثانية (الإنكليزية)
output-dir: lib/l10n/generated        # مكان الكود المُولّد تلقائياً
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

### ملفات الترجمة المصدرية
- `lib/l10n/app_ar.arb` — الترجمات العربية (وهي أيضاً القالب).
- `lib/l10n/app_en.arb` — الترجمات الإنكليزية.
- `lib/l10n/generated/` — الكود المُولّد (`app_localizations.dart` + فئة لكل لغة). **لا يُعدَّل يدوياً**، يُعاد توليده عند كل تغيير.

### كيفية ربط اللغة بالتطبيق (`lib/app/app.dart`)
```dart
MaterialApp.router(
  locale: locale,                                   // اللغة النشطة من LocaleController
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
)
```

### التحكم باللغة (`lib/app/localization/locale_controller.dart`)
- `localeControllerProvider` — `StateNotifierProvider<LocaleController, Locale>`.
- الافتراضي: `Locale('ar')` (العربية).
- تُقرأ اللغة المحفوظة من `AppPreferencesStorage` بمفتاح `'locale'`.
- `toggle()` و `setLocale()` يحفظان الاختيار.
- زر «لغة التطبيق» موجود في صفحة الإعدادات (`settings_page.dart`) ويستدعي `toggle()`.

### قاعدة الاستخدام في الواجهات
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.home);   // بدلاً من كتابة النص مباشرة
```

---

## 2) ما هو المترجم فعلياً الآن؟

**البنية جاهزة ومفعّلة بالكامل، لكن الملفات شبه فارغة والاستخدام معدوم عملياً:**

- ملفات ARB تحتوي على **6 مفاتيح فقط**:
  `appTitle`, `home`, `services`, `account`, `notifications`, `signOut`.
- البحث عن `AppLocalizations.of(context)` في كامل مجلد `lib` (عدا الكود المُولّد) يعيد **صفر نتيجة** — أي لا توجد واجهة واحدة تستخدم النظام.
- جميع نصوص الواجهات مكتوبة **كسلاسل عربية صلبة مباشرة في الكود**، وقد أحصيت **6161 موضع نص عربي** موزعة على **70 ملفاً** (بما فيها `app.dart` نفسه الذي يعرض رسالة «انتهت جلستك» حرفياً).

**الخلاصة:** نظام الترجمة «موجود ومركّب» لكنه **غير مستخدم**؛ تغيير اللغة من الإعدادات يغيّر `MaterialApp.locale` ويُعيد بناء الشاشات بنفس النصوص العربية لأن كل النصوص hardcoded.

---

## 3) هل الهيكلية صحيحة؟

| الجانب | الحالة | الملاحظة |
|---|---|---|
| تفعيل `generate: true` | ✅ صحيح | |
| وجود `flutter_localizations` و `intl` | ✅ صحيح | |
| ملف `l10n.yaml` | ✅ صحيح | |
| ملفات ARB بالعربية والإنكليزية | ✅ صحيح | |
| الكود المُولّد في `lib/l10n/generated` | ✅ صحيح | |
| ربط الـ delegates في `MaterialApp` | ✅ صحيح | |
| التحكم باللغة وحفظها | ✅ صحيح | |
| **استخدام `AppLocalizations` في الواجهات** | ❌ **غير مطبق** | المشكلة الوحيدة والجوهرية |
| **الترجمة الفعلية لكل نصوص التطبيق** | ❌ **غير موجودة** | 6161 نصاً عربياً مبعثرة في الكود |

**ملاحظات دقيقة على البنية:**
- جعل `template-arb-file` هو `app_ar.arb` أمر سليم (القالب يحدد أسماء المفاتيح)، والإنكليزية مخرَجٌ له.
- لا توجد ملفات `l10n.yaml` فرعية لكل فيتشر — المشروع يُجمّع كل الترجمات في ملفين مركزيين فقط، وهو نمط مقبول للكتابة الحالية لكنه سيكبر كثيراً مع اكتمال التطبيق.
- فئة `AppLocalizations` لا تملك دالة مساعدة مثل `context.l10n`؛ الاستخدام يتم عبر `AppLocalizations.of(context)` فقط (وهي موجودة في الكود المُولّد).

---

## 4) كيف نترجم التطبيق بالكامل؟

### الخطوة 1 — إضافة المفاتيح في ملفات ARB
نضيف في `app_ar.arb` مفتاحاً لكل نص عربي موجود في الكود، ونضيف مقابلَه في `app_en.arb`:
```json
{
  "@@locale": "ar",
  "appTitle": "دوائي",
  "settingsAccount": "حسابي",
  "settingsSubtitle": "بياناتك وتفضيلات استخدام التطبيق",
  ...
}
```
يمكن تقسيمها حسب الشاشات (مفاتيح بادئة مثل `loginEmail`, `inventoryAddMedicine`...) لتسهيل الصيانة.

### الخطوة 2 — توليد الكود
```bash
flutter gen-l10n
```
(يُنفَّذ تلقائياً أيضاً مع `flutter run` و `flutter build`).

### الخطوة 3 — استبدال النصوص الصلبة بالاستدعاءات
في كل واجهة:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.loginEmail);          // بدلاً من Text('البريد الإلكتروني')
SnackBar(content: Text(l10n.sessionExpired));
```
استبدال 6161 نصاً يدوياً مهمة ضخمة. **الطريقة العملية:**

1. **أتمتة الاستخراج:** كتابة سكربت يمسح `lib/**/*.dart` ويلتقط كل السلاسل العربية داخل `Text(...)` و `label: ...` ونحوها، ويولّد مفاتيحها تلقائياً في ملفي ARB (توليد id من النص أو ترقيم).
2. **استبدال نصف تلقائي:** بمساعدة الذكاء الاصطناعي أو `dart fix` مخصص لتحويل كل `Text('نص')` إلى `Text(l10n.someKey)` وإضافة السطر `final l10n = AppLocalizations.of(context);`.
3. **التحقق:** تشغيل `flutter analyze` ثم فحص شاشة تلو الأخرى، والتأكد من عدم بقاء أي نص عربي صريح في `lib/features` (عدا ملفات ARB).

### الخطوة 4 — نصوص ديناميكية (متغيرات / جمع / تواريخ)
النصوص التي تحوي قيماً متغيرة تحتاج مفاتيح مخصوصة:
```json
"medicineCount": "{count} من الأدوية"
```
```dart
Text(l10n.medicineCount(3));
```
والترقيم/التواريخ تمر عبر `intl` (مثلاً `NumberFormat` و `DateFormat` حسب `localeName`).

### الخطوة 5 — الالتزام بالنمط مستقبلاً
- قاعدة: **لا تكتب أي نص عربي/إنجليزي مباشرة في أي Widget** — دائماً عبر `l10n`.
- إضافة نص جديد = تعديل ملفي ARB فقط ثم إعادة التوليد.
- عند الإضافة للغة ثالثة: نسخة `app_XX.arb` جديدة + إضافتها لقائمة `supportedLocales` تلقائياً.

---

## 5) توصيات إضافية
- إضافة امتداد مساعد لاختصار الكتابة:
  ```dart
  extension AppLocalizationsX on BuildContext {
    AppLocalizations get l10n => AppLocalizations.of(this);
  }
  ```
  ليصبح الاستخدام `context.l10n.home`.
- تفريغ النصوص الثابتة في `app.dart` («انتهت جلستك...») ضمن المفاتيح أيضاً.
- بعد اكتمال الترجمة، اختبار RTL/LTR: العربية RTL والإنكليزية LTR — و`MaterialApp` يتعامل مع الاتجاه تلقائياً عبر `Directionality`، لكن ينبغي مراجعة الأيقونات (أسهم/أسهم خلف) والتخطيطات المبنية يدوياً.