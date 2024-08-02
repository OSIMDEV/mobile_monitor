import 'package:flutter/material.dart';

final class MonitorCallStackItem extends StatelessWidget {
  const MonitorCallStackItem({
    super.key,
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: color,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}
