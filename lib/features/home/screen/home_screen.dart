import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/features/create_alarm/data/alarm_model.dart';
import 'package:delarms/features/create_alarm/data/alarm_repository.dart';
import 'package:delarms/features/create_alarm/screen/create_alarm_screen.dart';
import 'package:delarms/features/home/screen/alarm_detail_screen.dart';
import 'package:delarms/widgets/alarm_list_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Alarm> _alarms = [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final alarms = await AlarmRepository.instance.getAllAlarms();
      if (!mounted) return;
      setState(() {
        _alarms = alarms;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Could not load alarms: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _setAlarmActive(Alarm alarm, bool isActive) async {
    final id = alarm.id;
    if (id == null) return;

    final previousValue = alarm.isActive;
    setState(() {
      _alarms = _alarms
          .map(
            (item) => item.id == id
                ? Alarm(
                    id: item.id,
                    hour: item.hour,
                    minute: item.minute,
                    label: item.label,
                    repeatDays: item.repeatDays,
                    preAlarmEnabled: item.preAlarmEnabled,
                    preAlarmMinutes: item.preAlarmMinutes,
                    qrImagePath: item.qrImagePath,
                    isActive: isActive,
                  )
                : item,
          )
          .toList();
    });

    try {
      await AlarmRepository.instance.setAlarmActive(id, isActive);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _alarms = _alarms
            .map(
              (item) => item.id == id
                  ? Alarm(
                      id: item.id,
                      hour: item.hour,
                      minute: item.minute,
                      label: item.label,
                      repeatDays: item.repeatDays,
                      preAlarmEnabled: item.preAlarmEnabled,
                      preAlarmMinutes: item.preAlarmMinutes,
                      qrImagePath: item.qrImagePath,
                      isActive: previousValue,
                    )
                  : item,
            )
            .toList();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update alarm: $error')));
    }
  }

  String _formatRepeatDays(List<String> days) {
    if (days.isEmpty) return 'Once';
    const weekdayOrder = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final sortedDays = [...days]
      ..sort((first, second) {
        return weekdayOrder
            .indexOf(first)
            .compareTo(weekdayOrder.indexOf(second));
      });
    return sortedDays.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.s64,
          horizontal: AppSizes.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alarm", style: AppTypography.headlineMedium),
            SizedBox(height: AppSizes.s12),
            Text(
              'Alarm Active (${_alarms.where((alarm) => alarm.isActive).length})',
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppSizes.s16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _loadError != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_loadError!, textAlign: TextAlign.center),
                          SizedBox(height: AppSizes.s12),
                          TextButton(
                            onPressed: _loadAlarms,
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    )
                  : _alarms.isEmpty
                  ? const Center(
                      child: Text('No alarms yet. Tap + to add one.'),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _alarms.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSizes.s16),
                      itemBuilder: (context, index) {
                        final alarm = _alarms[index];

                        return AlarmListCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AlarmDetailScreen(alarm: alarm),
                              ),
                            );
                          },
                          onChanged: (value) => _setAlarmActive(alarm, value),
                          isActive: alarm.isActive,
                          time: DateTime(2000, 1, 1, alarm.hour, alarm.minute),
                          label: alarm.label,
                          days: _formatRepeatDays(alarm.repeatDays),
                          qrPosition: alarm.qrImagePath == null
                              ? 'QR not set'
                              : 'QR uploaded',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: AppSizes.s8, bottom: AppSizes.s12),
        child: FloatingActionButton(
          onPressed: () async {
            final savedAlarm = await showModalBottomSheet<Alarm>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: AppColors.surface,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.94,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.r24),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              builder: (_) => const CreateAlarmScreen(),
            );
            if (savedAlarm != null) await _loadAlarms();
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
