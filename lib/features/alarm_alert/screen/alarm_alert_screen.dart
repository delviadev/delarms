import 'dart:ui' show ImageFilter;

import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/features/create_alarm/screen/scan_qr_result_screen.dart';
import 'package:flutter/material.dart';

class AlarmAlertScreen extends StatefulWidget {
  const AlarmAlertScreen({super.key});

  @override
  State<StatefulWidget> createState() => AlarmAlertScreenState();
}

class AlarmAlertScreenState extends State<AlarmAlertScreen>
    with SingleTickerProviderStateMixin {
  double _slideProgress = 0;
  late final AnimationController _slideHintController;

  @override
  void initState() {
    super.initState();
    _slideHintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideHintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.alarmBackground,
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.alarmBackground),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.9, -0.85),
                  radius: 1.2,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.48),
                    AppColors.primary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.48, 1],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.95, -0.05),
                  radius: 1.05,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.32),
                    AppColors.secondary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.52, 1],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.1, 1.1),
                  radius: 1.1,
                  colors: [
                    AppColors.primaryContainer.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.s64,
                horizontal: AppSizes.s24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '06:30',
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: AppSizes.s8),
                      Text(
                        'AM',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.s12),
                  _glassCard(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.s16,
                      vertical: AppSizes.s8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: AppSizes.s8,
                          color: Colors.green,
                        ),
                        SizedBox(width: AppSizes.s8),
                        Text(
                          'Wake Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.s32),
                  _glassCard(
                    padding: EdgeInsets.all(AppSizes.s16),
                    borderRadius: AppSizes.r20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _glassCard(
                          padding: EdgeInsets.all(AppSizes.s12),
                          borderRadius: AppSizes.rFull,
                          child: Icon(
                            Icons.qr_code_rounded,
                            size: AppSizes.s24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: AppSizes.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Alarm Location',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSizes.s4),
                              Text(
                                'Scan the QR code at its assigned location to turn off this alarm.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.s24,
            AppSizes.s16,
            AppSizes.s24,
            AppSizes.s16,
          ),
          child: _slideToScanButton(),
        ),
      ),
    );
  }

  Widget _slideToScanButton() {
    const thumbSize = 52.0;
    const thumbInset = AppSizes.s4;
    const hintDistance = 10.0;
    const sliderHeight = 64.0;
    const thumbVerticalInset = (sliderHeight - thumbSize) / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxTravel = (constraints.maxWidth - thumbSize - thumbInset * 2)
            .clamp(0.0, double.infinity);
        final thumbLeft = thumbInset + maxTravel * _slideProgress;

        return Semantics(
          label: 'Slide to turn off alarm',
          button: true,
          child: _glassCard(
            padding: EdgeInsets.zero,
            borderRadius: AppSizes.rFull,
            child: SizedBox(
              height: sliderHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.rFull),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: thumbLeft + thumbSize / 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryContainer.withValues(
                                alpha: 0.24,
                              ),
                              AppColors.primary.withValues(alpha: 0.12),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: _slideProgress > 0.35 ? 0.35 : 1,
                        duration: const Duration(milliseconds: 120),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Slide to turn off',
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: thumbLeft,
                      top: thumbVerticalInset,
                      bottom: thumbVerticalInset,
                      child: AnimatedBuilder(
                        animation: _slideHintController,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (maxTravel == 0) return;
                            _slideHintController.stop();
                            setState(() {
                              _slideProgress =
                                  (_slideProgress +
                                          details.delta.dx / maxTravel)
                                      .clamp(0.0, 1.0);
                            });
                          },
                          onHorizontalDragEnd: (_) => _finishSlide(),
                          child: SizedBox(
                            width: thumbSize,
                            child: Center(
                              child: Container(
                                width: thumbSize,
                                height: thumbSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.16,
                                      ),
                                      blurRadius: AppSizes.s8,
                                      offset: const Offset(0, AppSizes.s4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.notifications_off_outlined,
                                  size: AppSizes.s24,
                                  color: AppColors.alarmBackground,
                                ),
                              ),
                            ),
                          ),
                        ),
                        builder: (context, child) {
                          final hintOffset = _slideProgress == 0
                              ? Curves.easeInOut.transform(
                                      _slideHintController.value,
                                    ) *
                                    hintDistance
                              : 0.0;
                          return Transform.translate(
                            offset: Offset(hintOffset, 0),
                            child: child,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _finishSlide() async {
    final didComplete = _slideProgress >= 0.85;
    setState(() => _slideProgress = didComplete ? 1 : 0);

    if (!didComplete) {
      _slideHintController.repeat(reverse: true);
      return;
    }

    _slideHintController.stop();
    final scannedValue = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => ScanQrResultScreen(isSuccess: false, onAction: () {}),
      ),
    );
    if (!mounted) return;

    setState(() => _slideProgress = 0);
    _slideHintController.repeat(reverse: true);
    if (scannedValue != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('QR code scanned.')));
    }
  }

  Widget _glassCard({
    required Widget child,
    required EdgeInsetsGeometry padding,
    double borderRadius = AppSizes.rFull,
    bool showBorder = true,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.14),
                AppColors.primaryContainer.withValues(alpha: 0.07),
                Colors.white.withValues(alpha: 0.035),
              ],
              stops: const [0, 0.48, 1],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 0.8,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: AppSizes.s16,
                offset: const Offset(0, AppSizes.s4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
