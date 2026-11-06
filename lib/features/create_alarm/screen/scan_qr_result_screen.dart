import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';

class ScanQrResultScreen extends StatelessWidget {
  const ScanQrResultScreen({
    super.key,
    required this.isSuccess,
    required this.onAction,
  });

  final bool isSuccess;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final accentColor = isSuccess
        ? const Color(0xFF63D6A0)
        : const Color(0xFFFF7777);

    return Scaffold(
      backgroundColor: AppColors.alarmBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(AppSizes.s16, 0, AppSizes.s24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  color: Colors.white,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.s24),
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.38),
                        ),
                      ),
                      child: Icon(
                        isSuccess ? Icons.check_rounded : Icons.close_rounded,
                        size: AppSizes.s64,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.s32),
                    Text(
                      isSuccess
                          ? 'QR code confirmed'
                          : 'QR code not recognized',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppSizes.s12),
                    Text(
                      isSuccess
                          ? 'This is the QR code assigned to your alarm.'
                          : 'This QR code isn’t assigned to this alarm. Try scanning the correct one.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    const Spacer(),
                    AppPrimaryButton(
                      text: isSuccess ? 'Back to alarm' : 'Scan again',
                      onPressed: onAction,
                      backgroundColor: isSuccess
                          ? const Color(0xFF277A5A)
                          : AppColors.primary,
                    ),
                    SizedBox(height: AppSizes.s16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
