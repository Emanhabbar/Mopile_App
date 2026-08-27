import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.licenseVerificationTitle),
        actions: [
          IconButton(
            onPressed: () =>
                ref.invalidate(pharmacyLicenseVerificationProvider),
            tooltip: l10n.refreshStatus,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.reviewingStatus),
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
                    ? l10n.selectLicenseImage
                    : l10n.sendNewLicenseImage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndUpload() async {
    final l10n = AppLocalizations.of(context);
    const images = XTypeGroup(
      label: 'license images',
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
    );
    final file = await openFile(acceptedTypeGroups: const [images]);
    if (file == null || !mounted) return;
    final size = await file.length();
    if (size > 8 * 1024 * 1024) {
      _message(l10n.imageTooLarge, error: true);
      return;
    }

    setState(() => _uploading = true);
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .submitLicenseVerification(file);
      ref.invalidate(pharmacyLicenseVerificationProvider);
      _message(l10n.licenseSubmitted);
    } catch (error) {
      _message(
        error is ApiException ? error.localize(l10n) : l10n.licenseSubmitFailed,
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
    final l10n = AppLocalizations.of(context);
    final presentation = _statusPresentation(l10n, verification?.status);
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
                ? l10n.sendLicenseIntro
                : l10n.lastFileLabel(verification!.originalFileName),
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.beforeSendingTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _Tip(l10n.tipFullLicense),
          _Tip(l10n.tipClearDetails),
          _Tip(l10n.tipAcceptedFormats),
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reviewDetailsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _row(context, l10n.registeredNameLabel, verification.registeredName),
          if (verification.extractedName != null)
            _row(context, l10n.licenseNameLabel, verification.extractedName!),
          if (verification.registryNumber != null)
            _row(context, l10n.registryNumberLabel, verification.registryNumber!),
          if (verification.documentSerialNumber != null)
            _row(context, l10n.documentNumberLabel, verification.documentSerialNumber!),
          _row(context, l10n.attemptCountLabel, '${verification.attemptCount}'),
          if (verification.manualReviewNote != null)
            _row(context, l10n.manualReviewNoteLabel, verification.manualReviewNote!),
        ],
      ),
    ),
    );
  }

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

(String, IconData) _statusPresentation(AppLocalizations l10n, String? value) {
  switch (value?.toLowerCase()) {
    case 'approved':
    case 'verified':
      return (l10n.licenseStatusVerified, Icons.verified_rounded);
    case 'rejected':
      return (l10n.licenseStatusRejected, Icons.error_outline_rounded);
    case 'failed':
      return (l10n.licenseStatusFailed, Icons.document_scanner_outlined);
    case 'manualreview':
    case 'manual_review':
      return (l10n.licenseStatusManualReview, Icons.manage_search_rounded);
    case 'pending':
    case 'processing':
      return (l10n.licenseStatusProcessing, Icons.hourglass_top_rounded);
    default:
      return (l10n.licenseStatusDefault, Icons.badge_outlined);
  }
}
