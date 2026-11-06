class Alarm {
  final int? id;
  final int hour;
  final int minute;
  final String label;
  final List<String> repeatDays;
  final bool preAlarmEnabled;
  final int preAlarmMinutes;
  final String? qrImagePath;
  final bool isActive;

  Alarm({
    this.id,
    required this.hour,
    required this.minute,
    required this.label,
    this.repeatDays = const [],
    this.preAlarmEnabled = false,
    this.preAlarmMinutes = 0,
    this.qrImagePath,
    required this.isActive,
  });

  factory Alarm.fromMap(Map<String, dynamic> map) {
    final repeatDaysRaw = map['repeat_days'] as String?;
    final List<String> parsedRepeatDays =
        (repeatDaysRaw != null && repeatDaysRaw.isNotEmpty)
        ? repeatDaysRaw.split(',')
        : [];

    return Alarm(
      id: map['id'] as int?,
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      label: map['label'] as String,
      repeatDays: parsedRepeatDays,
      preAlarmEnabled: (map['pre_alarm_enabled'] as int) == 1,
      preAlarmMinutes: map['pre_alarm_minutes'] as int,
      qrImagePath: map['qr_image_path'] as String?,
      isActive: (map['is_active'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'label': label,
      'repeat_days': repeatDays.join(','),
      'pre_alarm_enabled': preAlarmEnabled ? 1 : 0,
      'pre_alarm_minutes': preAlarmMinutes,
      'qr_image_path': qrImagePath,
      'is_active': isActive ? 1 : 0,
    };
  }
}
