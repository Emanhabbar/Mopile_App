# Medicines

ميزة دليل الأدوية المشتركة بين الحسابات المسجلة.

- `data/models`: نماذج الدواء، الصفحات، وطلب الإنشاء.
- `data/data_sources`: الاتصال بـ `GET/POST /api/Medicines`.
- `data/repositories`: واجهة الوصول إلى البيانات.
- `presentation/controllers`: Providers للقائمة والتفاصيل.
- `presentation/pages`: الدليل، التفاصيل، وإضافة دواء للإدمن.

إنشاء الدواء محمي في الـBackend والواجهة بدور `Admin`.
