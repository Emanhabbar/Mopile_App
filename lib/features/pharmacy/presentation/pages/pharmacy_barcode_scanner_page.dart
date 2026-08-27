import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PharmacyBarcodeScannerPage extends StatefulWidget {
  const PharmacyBarcodeScannerPage({super.key});

  @override
  State<PharmacyBarcodeScannerPage> createState() =>
      _PharmacyBarcodeScannerPageState();
}

class _PharmacyBarcodeScannerPageState
    extends State<PharmacyBarcodeScannerPage> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoZoom: true,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.itf14,
      BarcodeFormat.dataMatrix,
    ],
  );
  bool _completed = false;

  @override
  Future<void> dispose() async {
    await _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF061D23),
    appBar: AppBar(
      backgroundColor: const Color(0xFF061D23),
      foregroundColor: Colors.white,
      title: Text(AppLocalizations.of(context).scanMedicineBarcode),
      actions: [
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, state, _) => IconButton(
            onPressed: state.isInitialized ? _controller.toggleTorch : null,
            tooltip: AppLocalizations.of(context).toggleFlash,
            icon: Icon(
              state.torchState == TorchState.on
                  ? Icons.flash_on_rounded
                  : Icons.flash_off_rounded,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: _onDetect,
          placeholderBuilder: (_) => Center(
            child: CircularProgressIndicator(color: context.appColors.secondary),
          ),
          errorBuilder: (_, _) => ColoredBox(
            color: const Color(0xFF061D23),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.no_photography_outlined,
                      color: Colors.white70,
                      size: 44,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).cameraError,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _ScannerOverlay(secondaryColor: context.appColors.secondary),
        PositionedDirectional(
          start: 20,
          end: 20,
          bottom: 26,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    AppLocalizations.of(context).placeBarcodeInFrame,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _enterManually,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    backgroundColor: Colors.black.withValues(alpha: .35),
                  ),
                  icon: const Icon(Icons.keyboard_rounded),
                  label: Text(AppLocalizations.of(context).enterBarcodeManually),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  void _onDetect(BarcodeCapture capture) {
    if (_completed) return;
    final value = capture.barcodes
        .map((item) => item.rawValue?.trim())
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .firstOrNull;
    if (value == null) return;
    _complete(value);
  }

  Future<void> _enterManually() async {
    await _controller.stop();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final field = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.enterBarcodeTitle),
        content: TextField(
          controller: field,
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.barcodeNumberLabel,
            prefixIcon: const Icon(Icons.qr_code_2_rounded),
          ),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, field.text.trim()),
            child: Text(l10n.use),
          ),
        ],
      ),
    );
    field.dispose();
    if (value?.isNotEmpty == true) {
      _complete(value!);
    } else if (mounted) {
      await _controller.start();
    }
  }

  void _complete(String value) {
    if (_completed || !mounted) return;
    _completed = true;
    HapticFeedback.mediumImpact();
    Navigator.pop(context, value);
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({required this.secondaryColor});

  final Color secondaryColor;

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _ScannerOverlayPainter(secondaryColor: secondaryColor)));
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter({required this.secondaryColor});

  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final windowWidth = (size.width - 52).clamp(250.0, 380.0);
    final window = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * .42),
      width: windowWidth,
      height: 190,
    );
    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(window, const Radius.circular(24)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: .48));

    final border = Paint()
      ..color = secondaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(window, const Radius.circular(24)),
      border,
    );
    canvas.drawLine(
      Offset(window.left + 20, window.center.dy),
      Offset(window.right - 20, window.center.dy),
      Paint()
        ..color = secondaryColor.withValues(alpha: .75)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
