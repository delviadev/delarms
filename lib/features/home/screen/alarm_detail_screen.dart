import 'dart:io';

import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/features/create_alarm/data/alarm_model.dart';
import 'package:delarms/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AlarmDetailScreen extends StatelessWidget {
  const AlarmDetailScreen({super.key, required this.alarm});

  final Alarm alarm;

  String get _formattedTime {
    final hour = alarm.hour % 12 == 0 ? 12 : alarm.hour % 12;
    final minute = alarm.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${alarm.hour < 12 ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDim,
        title: const Text('Alarm Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSizes.s24),
        children: [
          AppCard(
            backgroundColor: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formattedTime,
                  style: AppTypography.displayMedium.copyWith(
                    color: AppColors.deepSlate,
                  ),
                ),
                SizedBox(height: AppSizes.s8),
                Text(alarm.label, style: AppTypography.headlineSmall),
                SizedBox(height: AppSizes.s16),
                Row(
                  children: [
                    Icon(
                      alarm.isActive
                          ? Icons.alarm_on_rounded
                          : Icons.alarm_off_rounded,
                      color: alarm.isActive
                          ? AppColors.primary
                          : AppColors.softSlate,
                    ),
                    SizedBox(width: AppSizes.s8),
                    Text(
                      alarm.isActive ? 'Active' : 'Inactive',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.s16),
          _detailCard(
            title: 'Repeat',
            icon: Icons.event_repeat_rounded,
            value: alarm.repeatDays.isEmpty
                ? 'Once'
                : _orderedRepeatDays(alarm.repeatDays).join(', '),
          ),
          SizedBox(height: AppSizes.s16),
          _detailCard(
            title: 'Pre-alarm',
            icon: Icons.notifications_active_outlined,
            value: alarm.preAlarmEnabled
                ? '${alarm.preAlarmMinutes} minutes before'
                : 'Off',
          ),
          SizedBox(height: AppSizes.s16),
          AppCard(
            backgroundColor: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.qr_code_rounded, color: AppColors.primary),
                    SizedBox(width: AppSizes.s8),
                    Text('Assigned QR code', style: AppTypography.bodyMedium),
                  ],
                ),
                SizedBox(height: AppSizes.s16),
                if (alarm.qrImagePath case final imagePath?)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.r16),
                    child: Image.file(
                      File(imagePath),
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            'QR image is unavailable',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Text('No QR image assigned', style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return AppCard(
      backgroundColor: AppColors.surface,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          SizedBox(width: AppSizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall),
                SizedBox(height: AppSizes.s4),
                Text(value, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _orderedRepeatDays(List<String> days) {
    const order = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return [...days]..sort((first, second) {
      return order.indexOf(first).compareTo(order.indexOf(second));
    });
  }
}
