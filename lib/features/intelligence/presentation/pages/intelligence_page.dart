import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_roles.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/intelligence_models.dart';
import '../../data/repositories/intelligence_repository.dart';

class IntelligencePage extends ConsumerStatefulWidget {
  const IntelligencePage({super.key});

  @override
  ConsumerState<IntelligencePage> createState() => _IntelligencePageState();
}

class _IntelligencePageState extends ConsumerState<IntelligencePage> {
  final _medicine = TextEditingController();
  final _stock = TextEditingController();
  final _sold = TextEditingController();
  final _average = TextEditingController();
  final _week = TextEditingController();
  final _monthSales = TextEditingController();
  AlternativeMedicineResult? _alternatives;
  StockoutPrediction? _prediction;
  bool _loadingAlternatives = false;
  bool _loadingPrediction = false;

  @override
  void dispose() {
    for (final controller in [
      _medicine,
      _stock,
      _sold,
      _average,
      _week,
      _monthSales,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref
        .watch(authControllerProvider)
        .valueOrNull
        ?.user
        .primaryRole;
    final canPredict = {
      AppRole.admin,
      AppRole.pharmacy,
      AppRole.warehouse,
    }.contains(role);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.intelligenceTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const _IntroCard(),
          const SizedBox(height: 18),
          Text(
            l10n.searchAlternativesTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          AppTextField(
            controller: _medicine,
            label: l10n.medicineNameLabel,
            hint: l10n.medicineAlternativesHint,
            icon: Icons.medication_outlined,
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: _loadingAlternatives ? null : _loadAlternatives,
            icon: const Icon(Icons.compare_arrows_rounded),
            label: Text(
              _loadingAlternatives
                  ? l10n.searchingProgress
                  : l10n.showAlternatives,
            ),
          ),
          if (_alternatives != null) ...[
            const SizedBox(height: 12),
            if (_alternatives!.alternatives.isEmpty)
              Text(
                l10n.noAlternativesFound,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              ..._alternatives!.alternatives.map(
                (item) => Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.medication_liquid_outlined,
                      color: context.appColors.primary,
                    ),
                    title: Text(item.medicineName),
                    subtitle: Text(
                      [
                        item.composition,
                        item.form,
                        item.manufacturer,
                      ].whereType<String>().join(' · '),
                    ),
                    trailing: Text(
                      '${(item.matchScore * 100).clamp(0, 100).round()}%',
                      style: TextStyle(
                        color: context.appColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
          ],
          if (canPredict) ...[
            const SizedBox(height: 24),
            Text(
              l10n.stockoutPredictionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _NumberField(_stock, l10n.stockLabel),
                _NumberField(_sold, l10n.soldLabel),
                _NumberField(_average, l10n.averageDailyLabel, decimal: true),
                _NumberField(_week, l10n.sales7DaysLabel),
                _NumberField(_monthSales, l10n.sales30DaysLabel),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _loadingPrediction ? null : _predict,
              icon: const Icon(Icons.auto_graph_rounded),
              label: Text(
                _loadingPrediction ? l10n.analyzing : l10n.analyzeStock,
              ),
            ),
            if (_prediction != null) ...[
              const SizedBox(height: 12),
              _PredictionCard(_prediction!),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _loadAlternatives() async {
    final l10n = AppLocalizations.of(context);
    final name = _medicine.text.trim();
    if (name.isEmpty) return _show(l10n.enterMedicineFirst, true);
    setState(() => _loadingAlternatives = true);
    try {
      final value = await ref
          .read(intelligenceRepositoryProvider)
          .getAlternatives(name);
      if (mounted) setState(() => _alternatives = value);
    } catch (error) {
      if (mounted) _show(_error(error, l10n), true);
    } finally {
      if (mounted) setState(() => _loadingAlternatives = false);
    }
  }

  Future<void> _predict() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _loadingPrediction = true);
    try {
      final value = await ref
          .read(intelligenceRepositoryProvider)
          .predictStockout(
            stockQuantity: int.tryParse(_stock.text) ?? 0,
            quantitySold: int.tryParse(_sold.text) ?? 0,
            averageDailyConsumption: double.tryParse(_average.text) ?? 0,
            last7DaysSales: int.tryParse(_week.text) ?? 0,
            last30DaysSales: int.tryParse(_monthSales.text) ?? 0,
            month: DateTime.now().month,
          );
      if (mounted) setState(() => _prediction = value);
    } catch (error) {
      if (mounted) _show(_error(error, l10n), true);
    } finally {
      if (mounted) setState(() => _loadingPrediction = false);
    }
  }

  void _show(String text, bool error) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? context.appColors.danger : null,
        ),
      );
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: context.appColors.surfaceSoft,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Icon(Icons.psychology_alt_outlined, color: context.appColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            AppLocalizations.of(context).intelligenceIntro,
          ),
        ),
      ],
    ),
  );
}

class _NumberField extends StatelessWidget {
  const _NumberField(this.controller, this.label, {this.decimal = false});
  final TextEditingController controller;
  final String label;
  final bool decimal;
  @override
  Widget build(BuildContext context) => AppTextField(
    controller: controller,
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    label: label,
  );
}

class _PredictionCard extends StatelessWidget {
  const _PredictionCard(this.value);
  final StockoutPrediction value;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.insights_rounded, color: context.appColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context).predictionResult(
                value.daysUntilStockout.toStringAsFixed(1),
                value.recommendedReorderQuantity,
              ),
            ),
          ),
          Text(
            value.riskLevel,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ),
  );
}

String _error(Object error, AppLocalizations l10n) => error is ApiException
    ? error.localize(l10n)
    : l10n.intelligenceUnavailable;
