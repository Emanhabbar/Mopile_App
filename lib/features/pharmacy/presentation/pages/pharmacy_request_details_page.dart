import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/async_states.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/models/pharmacy_models.dart';
import '../../data/repositories/pharmacy_repository.dart';
import '../controllers/pharmacy_providers.dart';

class PharmacyRequestDetailsPage extends ConsumerStatefulWidget {
  const PharmacyRequestDetailsPage({required this.requestId, super.key});
  final String requestId;
  @override
  ConsumerState<PharmacyRequestDetailsPage> createState() =>
      _PharmacyRequestDetailsPageState();
}

class _PharmacyRequestDetailsPageState
    extends ConsumerState<PharmacyRequestDetailsPage> {
  final _note = TextEditingController();
  String _status = 'Available';
  String? _alternative;
  bool _sending = false;
  bool _confirmingPickup = false;
  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pharmacyRequestDetailsProvider(widget.requestId));
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.requestDetailsTitle),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(
              pharmacyRequestDetailsProvider(widget.requestId),
            ),
            tooltip: l10n.refreshRequest,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.when(
        loading: () => AppLoadingState(label: l10n.openingRequest),
        error: (error, _) => AppErrorState(
          error: error,
          onRetry: () =>
              ref.invalidate(pharmacyRequestDetailsProvider(widget.requestId)),
        ),
        data: (data) {
          if (!data.isRequestedMedicineCurrentlyAvailable &&
              _status == 'Available') {
            _status = 'Unavailable';
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              _Hero(data: data),
              const SizedBox(height: 14),
              _InfoCard(data: data),
              const SizedBox(height: 14),
              _PatientCard(data: data),
              const SizedBox(height: 18),
              if (data.request.canRespond)
                _responseForm(data)
              else ...[
                _Processed(data: data),
                if (data.request.status.toLowerCase() == 'available') ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _confirmingPickup ? null : _confirmPickup,
                      icon: _confirmingPickup
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.inventory_rounded),
                      label: Text(
                        _confirmingPickup
                            ? l10n.confirmingProgress
                            : l10n.confirmUserPickup,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _responseForm(PharmacyRequestDetails data) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: context.appColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.quickreply_outlined,
                  color: Color(0xFF216474),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.respondToRequest,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l10n.replyWillReachUser,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ResponseChoice(
                  icon: Icons.check_circle_outline_rounded,
                  label: l10n.statusAvailable,
                  color: context.appColors.success,
                  selected: _status == 'Available',
                  enabled: data.isRequestedMedicineCurrentlyAvailable,
                  onTap: () => setState(() => _status = 'Available'),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _ResponseChoice(
                  icon: Icons.cancel_outlined,
                  label: l10n.statusUnavailable,
                  color: context.appColors.danger,
                  selected: _status == 'Unavailable',
                  onTap: () => setState(() => _status = 'Unavailable'),
                ),
              ),
            ],
          ),
          if (_status == 'Unavailable') ...[
            const SizedBox(height: 13),
            Text(
              l10n.suggestAlternativeHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 7),
            DropdownButtonFormField<String>(
              initialValue: _alternative,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.availableAlternativeLabel,
              ),
              items: data.alternativeCandidates
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) => setState(() => _alternative = value),
            ),
          ],
          const SizedBox(height: 13),
          TextField(
            controller: _note,
            maxLength: 1000,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: l10n.noteToUserOptional,
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _sending ? null : _send,
              icon: const Icon(Icons.send_rounded),
              label: Text(
                _sending ? l10n.sendingProgress : l10n.sendReply,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .remote
          .respondToRequest(
            widget.requestId,
            status: _status,
            responseNote: _note.text.trim().isEmpty ? null : _note.text.trim(),
            alternativeMedicineId: _alternative,
          );
      ref
        ..invalidate(pharmacyRequestDetailsProvider(widget.requestId))
        ..invalidate(pharmacyRequestsProvider)
        ..invalidate(pharmacyDashboardProvider);
      _message(l10n.replySent, false);
    } catch (error) {
      _message(
        error is ApiException ? error.localize(l10n) : l10n.sendReplyFailed,
        true,
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _confirmPickup() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _confirmingPickup = true);
    try {
      await ref
          .read(pharmacyRepositoryProvider)
          .confirmRequestPickup(widget.requestId);
      ref
        ..invalidate(pharmacyRequestDetailsProvider(widget.requestId))
        ..invalidate(pharmacyRequestsProvider)
        ..invalidate(pharmacyDashboardProvider);
      _message(l10n.pickupConfirmed, false);
    } catch (error) {
      _message(
        error is ApiException ? error.localize(l10n) : l10n.confirmPickupFailed,
        true,
      );
    } finally {
      if (mounted) setState(() => _confirmingPickup = false);
    }
  }

  void _message(String text, bool error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? context.appColors.danger : null,
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.data});
  final PharmacyRequestDetails data;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusColor = switch (data.request.status.toLowerCase()) {
      'available' => context.appColors.success,
      'unavailable' => context.appColors.danger,
      'cancelled' => context.appColors.textMuted,
      _ => context.appColors.secondary,
    };
    final statusText = data.request.statusDisplayText.trim().isNotEmpty
        ? data.request.statusDisplayText
        : l10n.requestStatusWaitingReply;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF216474), Color(0xFF102F37)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: context.appColors.secondary,
                  size: 27,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor == context.appColors.secondary
                        ? context.appColors.secondary
                        : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.request.medicineName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                l10n.quantityRequestedValue(data.request.requestedQuantity),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 9),
              Container(width: 1, height: 13, color: Colors.white24),
              const SizedBox(width: 9),
              Text(
                '#${data.request.requestCode}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.data});
  final PharmacyRequestDetails data;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(icon: Icons.science_outlined, title: l10n.medicineDataTitle),
          const SizedBox(height: 13),
          _DetailsRow(
            label: l10n.scientificNameLabel,
            value: data.requestedMedicineScientificName ?? l10n.notRegistered,
          ),
          if (data.requestedMedicineArabicScientificName != null)
            _DetailsRow(
              label: l10n.arabicNameLabel,
              value: data.requestedMedicineArabicScientificName!,
            ),
          _DetailsRow(
            label: l10n.formConcentrationLabel,
            value: [
              data.requestedMedicineDosageForm,
              data.requestedMedicineCapacity,
            ].whereType<String>().join(' · '),
          ),
          if (data.request.note != null) ...[
            const Divider(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.surfaceWarm,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(l10n.userNoteLabel(data.request.note!)),
            ),
          ],
        ],
      ),
    ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.data});
  final PharmacyRequestDetails data;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
    child: Padding(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.person_outline_rounded,
            title: l10n.userDataTitle,
          ),
          const SizedBox(height: 10),
          _ContactRow(
            icon: Icons.person_outline,
            label: l10n.nameLabel,
            value: data.request.userFullName,
          ),
          _ContactRow(
            icon: Icons.phone_outlined,
            label: l10n.phoneLabel,
            value: data.request.userPhoneNumber ?? l10n.notRegistered,
          ),
          _ContactRow(
            icon: Icons.email_outlined,
            label: l10n.emailLabel,
            value: data.userEmail,
          ),
        ],
      ),
    ),
    );
  }
}

class _ResponseChoice extends StatelessWidget {
  const _ResponseChoice({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? color.withValues(alpha: .1) : context.appColors.background,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? color : context.appColors.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: enabled ? color : context.appColors.textMuted, size: 19),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: enabled ? color : context.appColors.textMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: context.appColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: context.appColors.primary, size: 21),
      ),
      const SizedBox(width: 10),
      Text(title, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF668087), fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty
                ? AppLocalizations.of(context).notRegistered
                : value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: context.appColors.background,
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        Icon(icon, color: context.appColors.primary, size: 20),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(color: Color(0xFF668087), fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _Processed extends StatelessWidget {
  const _Processed({required this.data});
  final PharmacyRequestDetails data;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.appColors.success.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        const Icon(Icons.task_alt_rounded, color: Color(0xFF167D5A), size: 36),
        const SizedBox(height: 9),
        Text(
          AppLocalizations.of(context).requestProcessed,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        if (data.request.pharmacyResponseNote != null)
          Text(data.request.pharmacyResponseNote!, textAlign: TextAlign.center),
      ],
    ),
  );
}
