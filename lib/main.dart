import 'package:delarms/features/alarm_alert/screen/alarm_alert_screen.dart';
import 'package:delarms/features/home/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AlarmAlertScreen());
  }
}
