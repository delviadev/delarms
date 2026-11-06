import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  late final MobileScannerController _controller;
  bool _hasDetectedCode = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_hasDetectedCode) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null || value.isEmpty) continue;

      _hasDetectedCode = true;
      Navigator.of(context).pop(value);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.alarmBackground,
      body: ValueListenableBuilder<MobileScannerState>(
        valueListenable: _controller,
        builder: (context, state, _) {
          final error = state.error;
          if (error != null) return _scannerErrorScreen(error);

          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: _handleDetection,
                errorBuilder: (_, _) =>
                    const ColoredBox(color: AppColors.alarmBackground),
              ),
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.62),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.72),
                      ],
                      stops: const [0, 0.28, 0.62, 1],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSizes.s16,
                        0,
                        AppSizes.s24,
                        0,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            color: Colors.white,
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'Close scanner',
                          ),
                          Expanded(
                            child: Text(
                              'Scan QR code',
                              textAlign: TextAlign.center,
                              style: AppTypography.headlineSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed:
                                state.torchState == TorchState.unavailable
                                ? null
                                : _controller.toggleTorch,
                            color: Colors.white,
                            icon: Icon(
                              state.torchState == TorchState.on
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                            ),
                            tooltip: state.torchState == TorchState.on
                                ? 'Turn off flashlight'
                                : 'Turn on flashlight',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.s32),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(AppSizes.r24),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              size: AppSizes.s64,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.s24),
                    Text(
                      'Align the QR code within the frame',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSizes.s24,
                        0,
                        AppSizes.s24,
                        AppSizes.s32,
                      ),
                      child: Text(
                        'Scanning starts automatically',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _scannerErrorScreen(MobileScannerException error) {
    final hasPermissionError =
        error.errorCode == MobileScannerErrorCode.permissionDenied;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.s16,
          0,
          AppSizes.s32,
          AppSizes.s32,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                color: Colors.white,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Close scanner',
              ),
            ),
            const Spacer(),
            Icon(
              hasPermissionError
                  ? Icons.no_photography_outlined
                  : Icons.camera_alt_outlined,
              size: AppSizes.s40,
              color: Colors.white,
            ),
            SizedBox(height: AppSizes.s16),
            Text(
              hasPermissionError
                  ? 'Camera access is needed to scan QR codes'
                  : 'The camera could not be started',
              style: AppTypography.bodyLarge.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.s8),
            Text(
              hasPermissionError
                  ? 'Allow camera access in your device settings, then reopen the scanner.'
                  : 'Please close the scanner and try again.',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
