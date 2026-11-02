import 'package:delarms/core/theme/app_colors.dart';
import 'package:delarms/core/theme/app_sizes.dart';
import 'package:delarms/core/theme/app_typography.dart';
import 'package:delarms/features/create_alarm/screen/create_alarm_screen.dart';
import 'package:delarms/features/home/model/alarm_item_model.dart';
import 'package:delarms/widgets/alarm_list_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAlarmOn = true;

  final List<AlarmItemModel> alarmList = [
    AlarmItemModel(
      time: DateTime(2026, 1, 1, 6, 30),
      label: 'Morning Routine',
      days: 'Mon, Tue, Wed, Thu, Fri',
      qrPosition: 'Bathroom',
      isActive: true,
    ),
    AlarmItemModel(
      time: DateTime(2026, 1, 1, 7, 15),
      label: 'Gym & Workout',
      days: 'Mon, Wed, Fri',
      qrPosition: 'Kitchen',
      isActive: false,
    ),
    AlarmItemModel(
      time: DateTime(2026, 1, 1, 8, 00),
      label: 'Office Standup',
      days: 'Mon, Tue, Wed, Thu, Fri',
      qrPosition: 'Desk',
      isActive: true,
    ),
  ];

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
            Text('Alarm Active (4)', style: AppTypography.bodyMedium),
            SizedBox(height: AppSizes.s16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: alarmList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSizes.s16),
                itemBuilder: (context, index) {
                  final alarm = alarmList[index];

                  return AlarmListCard(
                    onChanged: (bool value) {
                      setState(() {
                        alarm.isActive = value;
                      });
                    },
                    time: alarm.time,
                    label: alarm.label,
                    days: alarm.days,
                    qrPosition: alarm.qrPosition,
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
          onPressed: () {
            showModalBottomSheet<void>(
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
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
