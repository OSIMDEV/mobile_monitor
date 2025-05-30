import 'package:flutter/material.dart';
import 'package:mobile_monitor/viewmodels/monitor_viewmodel.dart';
import 'package:provider/provider.dart';

class MonitorView extends StatelessWidget {
  const MonitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.select((MonitorViewmodel vm) => vm.logs);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Column(
            children: [
              Text(log.toJson(),
                  style: const TextStyle(fontSize: 16.0, color: Colors.black)),
              const SizedBox(height: 8.0),
            ],
          );
        },
      ),
    );
  }
}
