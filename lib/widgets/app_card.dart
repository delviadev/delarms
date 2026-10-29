import 'package:delarms/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.s20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.r24),
      ),
      child: widget.child,
    );
  }
}
