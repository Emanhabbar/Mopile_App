import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/prescription_models.dart';
import '../../data/repositories/prescriptions_repository.dart';
import '../controllers/prescriptions_providers.dart';

class PrescriptionsPage extends ConsumerStatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  ConsumerState<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends ConsumerState<PrescriptionsPage> {
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(myPrescriptionsProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPrescriptionsTitle)),
      body: orders.when(
        loading: () => AppLoadingState(label: l10n.prescriptionsLoading),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () => ref.invalidate(myPrescriptionsProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.refresh(myPrescriptionsProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              _UploadCard(uploading: _uploading, onUpload: _pickAndAnalyze),
              const SizedBox(height: 20),
              Text(
                l10n.previousPrescriptions,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const _EmptyPrescriptions()
              else
                ...items.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PrescriptionCard(
                      order: order,
                      onTap: () =>
                          context.push('/user/prescriptions/${order.id}'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndAnalyze() async {
    final l10n = AppLocalizations.of(context);
    const acceptedTypes = XTypeGroup(
      label: 'prescription',
      extensions: ['jpg', 'jpeg', 'png', 'pdf'],
      mimeTypes: ['image/jpeg', 'image/png', 'application/pdf'],
    );
    final file = await openFile(acceptedTypeGroups: const [acceptedTypes]);
    if (file == null) return;
    final fileSize = await file.length();
    if (fileSize <= 0 || fileSize > 10 * 1024 * 1024) {
      _message(l10n.prescriptionFileTooLarge, error: true);
      return;
    }

    setState(() => _uploading = true);
    try {
      final order = await ref
          .read(prescriptionsRepositoryProvider)
          .analyze(filePath: file.path, fileName: file.name);
      ref.invalidate(myPrescriptionsProvider);
      if (mounted) context.push('/user/prescriptions/${order.id}');
    } catch (error) {
      _message(
        error is ApiException ? error.localize(l10n) : l10n.prescriptionAnalyzeFailed,
        error: true,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _message(String text, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? context.appColors.danger : null,
        ),
      );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({required this.uploading, required this.onUpload});

  final bool uploading;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              Icons.document_scanner_outlined,
              color: context.appColors.primary,
              size: 38,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.addNewPrescription,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Text(
              l10n.uploadPrescriptionHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: uploading ? null : onUpload,
                icon: uploading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.upload_file_rounded),
                label: Text(
                  uploading ? l10n.analyzing : l10n.choosePrescription,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.order, required this.onTap});

  final PrescriptionOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = prescriptionStatusInfo(context.appColors, order.status, l10n);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: status.color.withValues(alpha: 0.1),
          child: Icon(status.icon, color: status.color),
        ),
        title: Text(
          order.originalFileName.isEmpty
              ? l10n.prescriptionFallbackTitle
              : order.originalFileName,
        ),
        subtitle: Text(
          '${l10n.prescriptionItemsCount(order.items.length)} · ${formatDate(order.createdAtUtc)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              status.label,
              style: TextStyle(
                color: status.color,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
            const Icon(Icons.chevron_left_rounded, size: 19),
          ],
        ),
      ),
    );
  }
}

class _EmptyPrescriptions extends StatelessWidget {
  const _EmptyPrescriptions();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: context.appColors.textMuted,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context).noPrescriptions),
        ],
      ),
    ),
  );
}

({String label, Color color, IconData icon}) prescriptionStatusInfo(
  AppColors colors,
  String status,
  AppLocalizations l10n,
) => switch (status.toLowerCase()) {
  'reserved' => (
    label: l10n.prescriptionStatusReserved,
    color: const Color(0xFFB47618),
    icon: Icons.bookmark_added_rounded,
  ),
  'readyforpickup' => (
    label: l10n.prescriptionStatusReady,
    color: colors.success,
    icon: Icons.inventory_2_rounded,
  ),
  'collected' => (
    label: l10n.prescriptionStatusCollected,
    color: colors.success,
    icon: Icons.task_alt_rounded,
  ),
  'expired' => (
    label: l10n.prescriptionStatusExpired,
    color: colors.textMuted,
    icon: Icons.timer_off_rounded,
  ),
  'cancelled' => (
    label: l10n.prescriptionStatusCancelled,
    color: colors.danger,
    icon: Icons.block_rounded,
  ),
  _ => (
    label: l10n.prescriptionStatusAnalyzed,
    color: colors.primary,
    icon: Icons.document_scanner_rounded,
  ),
};

String formatDate(DateTime value) =>
    '${value.year}/${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}';
