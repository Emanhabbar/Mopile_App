# سير عمل ترجمة تطبيق دوائي بالكامل (Workflow)

> هذا الملف هو **وثيقة استمرارية**. إذا توقفت الأداة أو انقطعت الجلسة، يعتمد أي وكيل قادم على هذا الملف لمتابعة العمل من حيث توقف بالضبط. لا تحذفه ولا تتجاوز الخطوات.

---

## 0) الحالة الحالية (Checkpoint)

آخر تحديث: **اكتملت فيتشرات auth + account + settings + user + chat + notifications + intelligence + pharmacy_discovery + صفحات المنظمات العامة — ~31 ملفاً محوَّلاً، 0 عربي متبقي فيها (عدا استثناء وظيفي).**

| القطعة | الحالة |
|---|---|
| البنية (l10n.yaml + ARB + delegates) | جاهزة وسليمة |
| سكربت الاستخراج | ✅ `tools/extract_arabic.ps1` — 1560 سلسلة فريدة في `tools/arabic_strings.json` |
| ملف `docs/TRANSLATION_WORKFLOW.md` | ✅ أُنشئ (هذا الملف) |
| المفاتيح في ARB | ✅ ~680 مفتاحاً (عربي + إنجليزي) |
| **فيتشر auth** | ✅ **كاملة** |
| **فيتشر account** | ✅ **كاملة** |
| **فيتشر settings** | ✅ **كاملة** |
| **فيتشر user** | ✅ **كاملة** (8 صفحات) |
| **فيتشر chat** | ✅ **كاملة** (chat_sessions + chat_page) |
| **فيتشر notifications** | ✅ **كاملة** |
| **فيتشر intelligence** | ✅ **كاملة** |
| **فيتشر pharmacy_discovery** | ✅ **كاملة** (external_pharmacy_details) |
| **صفحات المنظمات العامة** | ✅ **كاملة** (public_organizations + public_organization_details) |
| **فيتشر prescriptions** | ✅ **كاملة** (prescriptions, prescription_details, pharmacy_prescription_orders) |
| **فيتشر medicines** | ✅ **كاملة** (medicines_page, medicine_details, create_medicine) |
| **فيتشر donations** | ✅ **كاملة** (donations, pharmacy_donations, donation_form) |
| **فيتشر pharmacy (جزئي)** | ✅ 7/9 ملفات: barcode_scanner, requests, working_hours, request_details, license_verification, batch_inventory_editor, profile |
| `flutter analyze` | ✅ نظيف (6 تحذيرات سابقة غير متعلقة بالترجمة) |

**استثناء وظيفي موثّق:** `chat_page.dart` يحتوي 4 كلمات عربية (`'صيدلي'`, `'دواء'`, `'صحي'`, `'تبرع'`) داخل `_openAction` — مطابقة منطقية لتسميات إجراءات قادمة من الخادم (ليست نصوص UI، لا تُترجم عبر l10n).

**المتبقي: ~2630 موضعاً.** الدفعات القادمة بالترتيب:
1. ⏳ **pharmacy (باقي)** (inventory 326, dashboard 173, profile 118, batch_inventory_editor 96)
2. **organization** (workspace 310, home 95)
3. **supply_chain** (workspace 439, warehouse_home 102, representative_home 98)
4. **admin** (workspace 416, home 91)
5. **dashboard** (role_modules 171, overview 97, home_shell 60, modules_page 8)
6. **core/مؤجل** (api_exception 54, device_location_service 26, api_client 15, auth data 34, app_spacing 28, app_router 24, app_config 1, chat_models 2، بقايا data_sources 11)

ملاحظة: `donationStatus` (في donations_page) غيّرت توقيعها لتستقبل `AppLocalizations` — استدعاءاها في organization_workspace تم إصلاحهما مؤقتاً بتمرير l10n (سيُستكمل تحويل organization_workspace لاحقاً).

---

## 1) الهدف والمبادئ

استبدال كل نص عربي مكتوب hardcoded في `lib/**` باستدعاءات `AppLocalizations.of(context).keyName`.

قواعد ثابتة:
- لا نلمس الكود المُولّد `lib/l10n/generated/**` — يتولده `flutter gen-l10n`.
- لا نكتب أي سلسلة نصية جديدة في الواجهات بعد الآن.
- نعمل **ملفاً ملفاً**، ونتحقق بـ `flutter analyze` بعد كل دفعة.
- كل سلسلة فريدة تُضاف مرّة واحدة فقط في ARB.

---

## 2) بنية النظام (مرجع سريع)

- `l10n.yaml`: القالب `app_ar.arb` (العربية مصدر)، المخرج `app_en.arb`، الكود في `lib/l10n/generated`.
- اللغة تُدار عبر `localeControllerProvider` (افتراضي `ar`، محفوظة في Preferences بمفتاح `locale`).
- الاستخدام داخل الواجهة:
  ```dart
  final l10n = AppLocalizations.of(context);
  Text(l10n.loginTitle);
  ```

---

## 3) الخطوات الكاملة

### الخطوة 3.1 — تجهيز أدوات الاستخراج
1. إنشاء مجلد `tools/`.
2. كتابة سكربت `tools/extract_arabic.ps1` يستخرج كل السلاسل العربية الفريدة من `lib/` (باستثناء `lib/l10n/generated`).
3. تشغيله ليُنتج `tools/arabic_strings.json` (قائمة سلاسل فريدة + تكرارها + الملفات التي تظهر فيها).

### الخطوة 3.2 — توليد مفاتيح ARB (تُنفذ من قبل الوكيل)
- لكل سلسلة فريدة نُنشئ مفتاحاً camelCase ذا معنى (مثال: `'تسجيل الدخول'` → `loginTitle`).
- نضيفه في `lib/l10n/app_ar.arb` (القيمة العربية) و `lib/l10n/app_en.arb` (الترجمة الإنكليزية).
- السلاسل التي تحوي متغيرات (`'$name'` أو `'${x}'`) تصبح دوال:
  ```json
  "medicineCount": "{count} من الأدوية"
  ```
  ```dart
  Text(l10n.medicineCount(3));
  ```
  مع سطر `"medicineCount": "{count} من الأدوية"` و metadata مكانية اختيارية `"@medicineCount": {"placeholders": {...}}`.

### الخطوة 3.3 — توليد الكود
```powershell
flutter gen-l10n
```
يجب أن يعيد بناء `lib/l10n/generated/app_localizations*.dart` بدون أخطاء.

### الخطوة 3.4 — تحويل الواجهات (الجزء الأكبر)
نعمل بالترتيب التالي (الأصغر أولاً لتثبيت النمط):
1. ✅ `lib/app/app.dart`
2. ✅ `lib/core/widgets/async_states.dart`, ✅ `lib/core/widgets/app_brand.dart`
3. ⏳ `lib/core/errors/api_exception.dart` (ملف غير-Widget: **لا يمكن استخدام context مباشرة** — يحتاج تمرير `AppLocalizations` كمعامل أو تأجيل ترجمته؛ العربية تبقى احتياطاً مؤقتاً)
4. ⏳ `lib/core/location/device_location_service.dart`, ⏳ `lib/core/network/api_client.dart`
5. ⏳ `lib/features/auth/**` (login, register, forgot, splash, success, widgets, controller)
6. ثم كل فيتشر: `account, user, pharmacy, medicines, prescriptions, donations, chat, notifications, intelligence, organization, admin, supply_chain, settings`
7. `lib/features/dashboard/**` (role_modules.dart آخراً لأنه بيانات/مفاتيح)

**نمط الاستبدال في كل ملف:**
- أضف السطر `final l10n = AppLocalizations.of(context);` في أول `build`.
- استبدل `Text('نص')` → `Text(l10n.key)`.
- `label: 'نص'` / `tooltip: 'نص'` / `title: 'نص'` → نفس النمط.
- السلاسل التي تكون في `const` يجب إزالة `const` (لأن `l10n` ليس const).
- النصوص في كلاسات غير Widget أو دوال غير `build` (مثل factories أو helper data) تُعالج بحذر: إما تمرير `l10n` كمعامل، أو تركها للنهاية ضمن `role_modules.dart`/النماذج.

### الخطوة 3.5 — التحقق
```powershell
flutter analyze
```
- يجب ألا تظهر أخطاء `undefined_getter` أو `missing_argument`.
- التحذيرات الموجودة مسبقاً (registration_success_page, splash_page, role_modules, pharmacy_prescription_orders_page) مقبولة — لكن إن لمسناها ننظفها.

### الخطوة 3.6 — مراجعة RTL/LTR
- بعد اكتمال الترجمة، اختبار اللغة الإنكليزية: التأكد من توزيع الأيقونات (أسهم) والمسافات.

---

## 4) اصطلاحات تسمية المفاتيح

- بادئة بمجال الشاشة إن أمكن: `loginEmail`, `registerPhone`, `inventoryAdd`, `donationOfferTitle`.
- مفاتيح مشتركة تُستخدم في عدة شاشات: بادئة `common` (مثل `commonCancel`, `commonSave`, `commonRetry`).
- القيم المتغيرة: دوال بأسماء مثل `orderStatus(status)`.
- لا تكرر السلسلة في ملفين ARB — ملف واحد مركزي.

---

## 5) قائمة الملفات حسب الحجم (أولوية التحويل)

| الأولوية | الملف | عدد المواضع |
|---|---|---|
| ✅ 1 | `lib/app/app.dart` | 11 |
| ✅ 2 | `lib/core/widgets/async_states.dart` | 12 |
| ✅ 3 | `lib/core/widgets/app_brand.dart` | 3 |
| 4 | `lib/core/errors/api_exception.dart` | 54 |
| 5 | `lib/core/location/device_location_service.dart` | 26 |
| 6 | `lib/core/network/api_client.dart` | 15 |
| ✅ 7 | `lib/features/auth/presentation/pages/login_page.dart` | 47 |
| ✅ 8 | `lib/features/auth/presentation/pages/register_page.dart` | 233 |
| ✅ 9 | `lib/features/auth/presentation/pages/forgot_password_page.dart` | 96 |
| ✅ 10 | `lib/features/auth/presentation/pages/registration_success_page.dart` | 47 |
| 11 | `lib/features/auth/data/data_sources/auth_remote_data_source.dart` | 19 |
| ✅ 12 | `lib/features/auth/presentation/pages/splash_page.dart` | 18 |
| 13 | `lib/features/auth/data/models/password_reset_result.dart` | 8 |
| ✅ 14 | `lib/features/auth/presentation/controllers/auth_controller.dart` | 7 (تعليق فقط) |
| ✅ | `lib/features/auth/presentation/widgets/auth_widgets.dart` | 0 |
| ... | باقي الملفات بالترتيب التنازلي أعلاه (راجع الجدول في الجلسة الأولى) |

> **ملاحظة `api_exception.dart`:** ملف غير-Widget بلا `BuildContext`. الخياران: (أ) إضافة معامل `AppLocalizations l10n` لـ `fromDio` وتمريره من المتصلين، أو (ب) إبقاء العربية احتياطاً مؤقتاً والترجمة لاحقاً عبر طبقة عرض. نُوصي بالخيار (أ) لكنه يتطلب تعديل كل مواقع الاستدعاء — ابدأ منه إذا رغبت، أو تجاوزه مؤقتاً.

> **ملاحظة ملفات `core/location/device_location_service.dart` و`core/network/api_client.dart`:** كلاهما خدمة غير-Widget ترمي `ApiException` بنص عربي — تُعامل بنفس طريقة `api_exception.dart` (مؤجلة لدفعة الخدمات).

> الجدول الكامل بالحجم موجود في مخرجات جلسة العمل الأولى؛ أعد توليده بأمر PowerShell إذا ضاع:
> ```powershell
> Get-ChildItem lib -Recurse -Filter *.dart | Where-Object { $_.FullName -notlike '*generated*' } | ForEach-Object { $c = [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($_.FullName)); [pscustomobject]@{ File = $_.FullName.Replace((Get-Location).Path+'\',''); N = ([regex]::Matches($c,"[\u0600-\u06FF]{2,}")).Count } } | Sort-Object N -Descending | Format-Table -AutoSize
> ```

---

## 6) نصائح لإكمال الجلسة المقطوعة

1. أولاً: اقرأ `l10n.yaml` و `lib/l10n/app_ar.arb` و `lib/l10n/generated/app_localizations.dart` لفهم الوضع.
2. شغّل `flutter gen-l10n` للتأكد أن البنية سليمة.
3. افحص `git status`/`git diff` إن وجد repo (المشروع حالياً ليس git repo) لتعرف ما تم.
4. استأنف من آخر ملف غير محوَّل في قائمة الأولوية.
5. بعد كل ملف: `flutter analyze` للتأكد.

---

## 7) أوامر مفيدة

```powershell
# توليد كود الترجمة
flutter gen-l10n

# فحص الأخطاء
flutter analyze

# إعادة توليد جدول أحجام الملفات
# (الأمر أعلاه في القسم 5)

# فحص عدد السلاسل الفريدة المستخرجة
Get-Content tools/arabic_strings.json | ConvertFrom-Json | Measure-Object
```