import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/app_colors.dart';

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
      title: const Text('مسح باركود الدواء'),
      actions: [
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, state, _) => IconButton(
            onPressed: state.isInitialized ? _controller.toggleTorch : null,
            tooltip: 'تشغيل الإضاءة',
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
          placeholderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: AppColors.secondary),
          ),
          errorBuilder: (_, _) => const ColoredBox(
            color: Color(0xFF061D23),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.no_photography_outlined,
                      color: Colors.white70,
                      size: 44,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'تعذر تشغيل الكاميرا. اسمح للتطبيق باستخدامها أو أدخل الباركود يدوياً.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const _ScannerOverlay(),
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
                  child: const Text(
                    'ضع الرمز داخل الإطار وثبّت الهاتف للحظة',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
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
                  label: const Text('إدخال الباركود يدوياً'),
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
    final field = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إدخال الباركود'),
        content: TextField(
          controller: field,
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'رقم الباركود',
            prefixIcon: Icon(Icons.qr_code_2_rounded),
          ),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, field.text.trim()),
            child: const Text('استخدام'),
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
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _ScannerOverlayPainter()));
}

class _ScannerOverlayPainter extends CustomPainter {
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
      ..color = AppColors.secondary
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
        ..color = AppColors.secondary.withValues(alpha: .75)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
