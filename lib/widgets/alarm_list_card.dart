import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AlarmListCard extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;
  final bool isActive;
  final DateTime time;
  final String label;
  final String days;
  final String qrPosition;

  const AlarmListCard({
    super.key,
    required this.onChanged,
    required this.onTap,
    required this.isActive,
    required this.time,
    required this.label,
    required this.days,
    required this.qrPosition,
  });

  @override
  State<StatefulWidget> createState() => AlarmListCardState();
}

class AlarmListCardState extends State<AlarmListCard> {
  @override
  Widget build(BuildContext context) {
    final hour = widget.time.hour;
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSizes.r24),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.r24),
        onTap: widget.onTap,
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${displayHour.toString().padLeft(2, '0')}:${widget.time.minute.toString().padLeft(2, '0')}',
                    style: AppTypography.headlineLarge.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: AppSizes.s4),
                  Text(hour < 12 ? 'AM' : 'PM', style: AppTypography.bodySmall),
                  const Spacer(),
                  Switch(
                    value: widget.isActive,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                    inactiveThumbColor: AppColors.softSlate,
                    inactiveTrackColor: AppColors.softSlate.withValues(
                      alpha: 0.12,
                    ),
                    onChanged: widget.onChanged,
                  ),
                ],
              ),
              SizedBox(height: AppSizes.s4),
              Text(widget.label, style: AppTypography.bodyMedium),
              SizedBox(height: AppSizes.s16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.days,
                      style: AppTypography.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: AppSizes.s8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.s8,
                      vertical: AppSizes.s4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(AppSizes.r16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: AppSizes.s16,
                          color: Colors.black,
                        ),
                        SizedBox(width: AppSizes.s4),
                        Text(
                          widget.qrPosition,
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
