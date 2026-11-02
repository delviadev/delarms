import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/widgets/app_card.dart';
import 'package:delarms/widgets/app_primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAlarmScreen extends StatefulWidget {
  const CreateAlarmScreen({super.key});

  @override
  State<CreateAlarmScreen> createState() => _CreateAlarmScreenState();
}

class _CreateAlarmScreenState extends State<CreateAlarmScreen> {
  static const List<String> _weekdayLabels = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  int _hour = 6;
  int _minute = 30;
  int _preAlarmMinutes = 15;
  bool _isPreAlarmEnabled = false;
  final Set<int> _selectedRepeatDays = {0};
  final TextEditingController _alarmLabelController = TextEditingController(
    text: 'Morning Energy & Hydrate',
  );

  late final FixedExtentScrollController _hourScrollController;
  late final FixedExtentScrollController _minuteScrollController;
  late final FixedExtentScrollController _preAlarmScrollController;

  @override
  void initState() {
    super.initState();
    _hourScrollController = FixedExtentScrollController(initialItem: _hour);
    _minuteScrollController = FixedExtentScrollController(initialItem: _minute);
    _preAlarmScrollController = FixedExtentScrollController(
      initialItem: _preAlarmMinutes,
    );
  }

  @override
  void dispose() {
    _hourScrollController.dispose();
    _minuteScrollController.dispose();
    _preAlarmScrollController.dispose();
    _alarmLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.s24,
            0,
            AppSizes.s24,
            AppSizes.s24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("New Alarm", style: AppTypography.headlineMedium),
              SizedBox(height: AppSizes.s12),
              _alarmTimeSection(),
              SizedBox(height: AppSizes.s24),
              _preAlarmAlertSection(),
              SizedBox(height: AppSizes.s24),
              _alarmLabelSection(),
              SizedBox(height: AppSizes.s24),
              _repeatScheduleSection(),
              SizedBox(height: AppSizes.s24),
              _assignedQrCodeSection(),
            ],
          ),
        ),
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
          child: AppPrimaryButton(
            text: 'Save alarm',
            icon: Icons.alarm_add_rounded,
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _alarmTimeSection() {
    return AppCard(
      backgroundColor: AppColors.surfaceDim,
      padding: EdgeInsets.symmetric(vertical: AppSizes.r32),
      child: Column(
        children: [
          Row(
            children: [
              _numberPicker(
                value: _hour,
                max: 23,
                scrollController: _hourScrollController,
                onChanged: (value) => setState(() => _hour = value),
                onTap: () => _editAlarmTime(isHour: true),
              ),
              const Text(':', style: TextStyle(fontSize: 32)),
              _numberPicker(
                value: _minute,
                max: 59,
                scrollController: _minuteScrollController,
                onChanged: (value) => setState(() => _minute = value),
                onTap: () => _editAlarmTime(isHour: false),
              ),
            ],
          ),
          SizedBox(height: AppSizes.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.alarm_outlined, size: AppSizes.s16),
              SizedBox(width: AppSizes.s4),
              Text("Alarm rings in 8 hours, 49 minutes"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preAlarmAlertSection() {
    return AppCard(
      backgroundColor: AppColors.surfaceDim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: AppSizes.s20,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSizes.s8),
              Expanded(
                child: Text('Pre-alarm alert', style: AppTypography.bodyMedium),
              ),
              Switch(
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: _isPreAlarmEnabled,
                activeTrackColor: AppColors.primary,
                onChanged: (value) =>
                    setState(() => _isPreAlarmEnabled = value),
              ),
            ],
          ),
          SizedBox(height: AppSizes.s4),
          Text(
            "A pre-alarm to give you time to get ready before the main alarm rings.",
            style: AppTypography.bodySmall.copyWith(color: AppColors.deepSlate),
          ),
          if (_isPreAlarmEnabled) ...[
            Column(
              children: [
                _numberPicker(
                  value: _preAlarmMinutes,
                  max: 59,
                  scrollController: _preAlarmScrollController,
                  onChanged: (value) =>
                      setState(() => _preAlarmMinutes = value),
                  isCompact: true,
                ),
                Text(
                  'minutes before the main alarm',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.deepSlate,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _alarmLabelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Alarm Label", style: AppTypography.bodyMedium),
        SizedBox(height: AppSizes.s8),
        AppCard(
          backgroundColor: AppColors.surfaceDim,
          child: Row(
            children: [
              Icon(Icons.notes_rounded, size: AppSizes.s16),
              SizedBox(width: AppSizes.s12),
              Expanded(
                child: TextField(
                  controller: _alarmLabelController,
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  style: AppTypography.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'Alarm name',
                    border: InputBorder.none,
                    counterText: '',
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: _alarmLabelController.clear,
                icon: const Icon(Icons.delete_rounded, size: AppSizes.s16),
                visualDensity: VisualDensity.compact,
                tooltip: 'Clear alarm name',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _repeatScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Repeat Schedule", style: AppTypography.bodyMedium),
            Text(
              "Every Week",
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.s8),
        Row(
          children: [
            for (var index = 0; index < _weekdayLabels.length; index++)
              _repeatDayPicker(index),
          ],
        ),
      ],
    );
  }

  Widget _repeatDayPicker(int index) {
    final isSelected = _selectedRepeatDays.contains(index);
    final label = Text(
      _weekdayLabels[index],
      style: AppTypography.bodyMedium.copyWith(
        color: isSelected ? Colors.white : AppColors.deepSlate,
      ),
    );

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          right: index == _weekdayLabels.length - 1 ? 0 : AppSizes.s4,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSizes.r20),
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedRepeatDays.remove(index);
                } else {
                  _selectedRepeatDays.add(index);
                }
              });
            },
            child: AppCard(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.s4,
                vertical: AppSizes.s8,
              ),
              borderRadius: AppSizes.r20,
              backgroundColor: isSelected ? AppColors.primary : Colors.white,
              child: SizedBox(
                height: AppSizes.s40,
                child: isSelected
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          label,
                          const Icon(
                            Icons.check,
                            size: AppSizes.s16,
                            color: Colors.white,
                          ),
                        ],
                      )
                    : Center(child: label),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _assignedQrCodeSection() {
    return AppCard(
      backgroundColor: AppColors.surfaceDim,
      padding: EdgeInsets.all(AppSizes.s16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppCard(
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                padding: EdgeInsets.all(AppSizes.s12),
                child: Icon(
                  Icons.qr_code,
                  size: AppSizes.s20,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppSizes.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assigned QR Code", style: AppTypography.bodyMedium),
                  Text("QR Code Position", style: AppTypography.bodyMedium),
                ],
              ),
            ],
          ),
          AppCard(
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
              vertical: AppSizes.s8,
            ),
            child: Text(
              "Change",
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberPicker({
    required int value,
    required int max,
    required FixedExtentScrollController scrollController,
    required ValueChanged<int> onChanged,
    VoidCallback? onTap,
    bool isCompact = false,
  }) {
    const pickerHeight = 100.0;
    final pickerContainerHeight = pickerHeight + (isCompact ? 36 : 24);
    final cardHeight = isCompact ? 56.0 : 80.0;
    final arrowSize = isCompact ? AppSizes.s12 : AppSizes.s16;
    final arrowOffset =
        (pickerContainerHeight - cardHeight) / 2 - arrowSize - AppSizes.s8;
    final picker = SizedBox(
      height: pickerContainerHeight,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              borderRadius: isCompact ? AppSizes.r12 : AppSizes.r16,
              child: SizedBox(
                width: isCompact ? 72 : 96,
                height: isCompact ? 56 : 80,
              ),
            ),
            SizedBox(
              height: pickerHeight,
              child: CupertinoPicker(
                backgroundColor: Colors.transparent,
                itemExtent: isCompact ? 48 : 64,
                scrollController: scrollController,
                selectionOverlay: const SizedBox.shrink(),
                onSelectedItemChanged: onChanged,
                children: List.generate(
                  max + 1,
                  (index) => Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style:
                          (isCompact
                                  ? AppTypography.bodyLarge.copyWith(
                                      fontSize: 24,
                                    )
                                  : AppTypography.displayMedium)
                              .copyWith(
                                color: index == value
                                    ? Colors.black
                                    : Colors.transparent,
                              ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: arrowOffset,
              child: Icon(
                CupertinoIcons.chevron_up,
                size: arrowSize,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              bottom: arrowOffset,
              child: Icon(
                CupertinoIcons.chevron_down,
                size: arrowSize,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );

    return isCompact ? picker : Expanded(child: picker);
  }

  Future<void> _editAlarmTime({required bool isHour}) async {
    final current = isHour ? _hour : _minute;
    final controller = TextEditingController(text: '$current');

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isHour ? 'Pilih jam' : 'Pilih menit'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, int.tryParse(controller.text)),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (!mounted || result == null) return;

    final value = result.clamp(0, isHour ? 23 : 59);
    setState(() {
      if (isHour) {
        _hour = value;
        _hourScrollController.jumpToItem(value);
      } else {
        _minute = value;
        _minuteScrollController.jumpToItem(value);
      }
    });
  }
}
