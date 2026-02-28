import 'package:flutter/material.dart';
import 'package:gesture_coordination_task/configs/extension.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme=context.theme;
    return Container(
      decoration: BoxDecoration(
        color:theme.colorScheme.onPrimary ,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );;
  }
}
