import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyLicenseVerificationPage extends ConsumerStatefulWidget {
  const PharmacyLicenseVerificationPage({super.key});

  @override
  ConsumerState<PharmacyLicenseVerificationPage> createState() =>
      _PharmacyLicenseVerificationPageState();
}

class _PharmacyLicenseVerificationPageState
    extends ConsumerState<PharmacyLicenseVerificationPage> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyLicenseVerificationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من ترخيص الصيدلية'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.invalidate(pharmacyLicenseVerificationProvider),
            tooltip: 'تحديث الحالة',
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => const AppLoadingState(label: 'جاري مراجعة الحالة...'),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(pharmacyLicenseVerificationProvider),
        ),
        data: (verification) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            _Header(verification: verification),
            const SizedBox(height: 16),
            _Instructions(verification: verification),
            if (verification != null) ...[
              const SizedBox(height: 16),
              _VerificationDetails(verification: verification),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _uploading ? null : _selectAndUpload,
              icon: _uploading
                  ? const SizedBox.square(
                      dimension: 19,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.upload_file_rounded),
              label: Text(
                verification == null
                    ? 'اختيار صورة الترخيص وإرسالها'
                    : 'إرسال صورة أحدث للترخيص',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndUpload() async {
    const images = XTypeGroup(
      label: 'صور الترخيص',
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
    );
    final file = await openFile(acceptedTypeGroups: const [images]);
    if (file == null || !mounted) return;
    final size = await file.length();
    if (size > 8 * 1024 * 1024) {
      _message('حجم الصورة يجب ألا يتجاوز 8 ميغابايت.', error: true);
      return;
    }

    setState(() => _uploading = true);
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .submitLicenseVerification(file);
      ref.invalidate(pharmacyLicenseVerificationProvider);
      _message('تم إرسال الترخيص، ويمكنك متابعة نتيجة المراجعة من هنا.');
    } catch (error) {
      _message(
        error is ApiException ? error.message : 'تعذر إرسال صورة الترخيص.',
        error: true,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _message(String text, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? context.appColors.danger : context.appColors.success,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.verification});
  final PharmacyLicenseVerification? verification;

  @override
  Widget build(BuildContext context) {
    final presentation = _statusPresentation(verification?.status);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [context.appColors.primaryDeep, context.appColors.primary],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Icon(presentation.$2, color: context.appColors.secondary, size: 32),
          ),
          const SizedBox(height: 13),
          Text(
            presentation.$1,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            verification == null
                ? 'أرسل صورة واضحة من الترخيص لبدء المراجعة.'
                : 'آخر ملف: ${verification!.originalFileName}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions({required this.verification});
  final PharmacyLicenseVerification? verification;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('قبل الإرسال', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const _Tip('التقط الترخيص كاملاً دون قص الحواف.'),
          const _Tip('تأكد من وضوح الاسم والرقم والأختام.'),
          const _Tip('الصيغ المقبولة: JPG أو PNG أو WEBP.'),
          if (verification?.failureReason != null ||
              verification?.rejectionReason != null) ...[
            const Divider(height: 24),
            Text(
              verification!.rejectionReason ?? verification!.failureReason!,
              style: TextStyle(
                color: context.appColors.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class _Tip extends StatelessWidget {
  const _Tip(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: context.appColors.primary,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}

class _VerificationDetails extends StatelessWidget {
  const _VerificationDetails({required this.verification});
  final PharmacyLicenseVerification verification;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل المراجعة',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _row(context, 'الاسم المسجل', verification.registeredName),
          if (verification.extractedName != null)
            _row(context, 'الاسم في الترخيص', verification.extractedName!),
          if (verification.registryNumber != null)
            _row(context, 'رقم السجل', verification.registryNumber!),
          if (verification.documentSerialNumber != null)
            _row(context, 'رقم الوثيقة', verification.documentSerialNumber!),
          _row(context, 'عدد مرات الإرسال', '${verification.attemptCount}'),
          if (verification.manualReviewNote != null)
            _row(context, 'ملاحظة المراجعة', verification.manualReviewNote!),
        ],
      ),
    ),
  );

  Widget _row(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 115,
          child: Text(
            label,
            style: TextStyle(color: context.appColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

(String, IconData) _statusPresentation(String? value) {
  switch (value?.toLowerCase()) {
    case 'approved':
    case 'verified':
      return ('تم التحقق من الترخيص', Icons.verified_rounded);
    case 'rejected':
      return ('يحتاج الترخيص إلى إعادة إرسال', Icons.error_outline_rounded);
    case 'failed':
      return ('تعذرت قراءة الترخيص', Icons.document_scanner_outlined);
    case 'manualreview':
    case 'manual_review':
      return ('قيد المراجعة', Icons.manage_search_rounded);
    case 'pending':
    case 'processing':
      return ('جاري مراجعة الترخيص', Icons.hourglass_top_rounded);
    default:
      return ('توثيق ترخيص الصيدلية', Icons.badge_outlined);
  }
}
