import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/helper/date_helper.dart';
import 'package:delarms/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AlarmListCard extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final DateTime time;
  final String label;
  final String days;
  final String qrPosition;

  const AlarmListCard({
    super.key,
    required this.onChanged,
    required this.time,
    required this.label,
    required this.days,
    required this.qrPosition,
  });

  @override
  State<StatefulWidget> createState() => AlarmListCardState();
}

class AlarmListCardState extends State<AlarmListCard> {
  bool _isOn = false;

  // helper HH:Mm
  // helper AM/PM

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateHelper.formatHHmm(widget.time),
                style: AppTypography.headlineLarge.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: AppSizes.s4),
              Text('AM', style: AppTypography.bodySmall),
              const Spacer(), // Opsional: Memberi jarak agar Radio terdorong ke kanan
              Switch(
                value: _isOn,
                inactiveThumbColor: AppColors.softSlate,
                inactiveTrackColor: AppColors.softSlate.withAlpha(8),
                onChanged: (bool value) {
                  setState(() {
                    _isOn = value;
                  });
                },
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
                    Text(widget.qrPosition, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
