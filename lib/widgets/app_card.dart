import 'package:delarms/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Widget child;

  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(AppSizes.s20),
    this.borderRadius = AppSizes.r24,
  });

  @override
  State<StatefulWidget> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: widget.child,
    );
  }
}
