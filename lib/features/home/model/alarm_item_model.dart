class AlarmItemModel {
  final DateTime time;
  final String label;
  final String days;
  final String qrPosition;
  bool isActive;

  AlarmItemModel({
    required this.time,
    required this.label,
    required this.days,
    required this.qrPosition,
    this.isActive = true,
  });
}
