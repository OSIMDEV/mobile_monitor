import 'package:flutter/material.dart';
import 'package:mobile_monitor/services/monitor_service.dart';
import 'package:mobile_monitor/utils/qr_utils.dart';
import 'package:mobile_monitor/viewmodels/monitor_viewmodel.dart';
import 'package:mobile_monitor/views/monitor_view.dart';
import 'package:provider/provider.dart';

void main() async {
  final service = MonitorService();
  await service.init();
  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required MonitorService service})
      : _service = service;

  final MonitorService _service;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MonitorService>(
          create: (_) => _service,
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider(
          create: (_) => MonitorViewmodel(_service),
        ),
      ],
      child: MaterialApp(
        title: 'Log Monitor',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ip = context.select((MonitorViewmodel vm) => vm.ip);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(ip),
        actions: [
          GestureDetector(
            child: const Icon(
              Icons.qr_code,
            ),
            onTap: () {
              final width = 0.6 * MediaQuery.of(context).size.width;
              showGeneralDialog(
                context: context,
                barrierLabel: 'Barrier Label',
                barrierDismissible: true,
                transitionDuration: const Duration(
                  milliseconds: 200,
                ),
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Align(
                    alignment: Alignment.center,
                    child: Card(
                      color: Colors.white,
                      child: SizedBox.square(
                        dimension: width,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: QrView(
                            ip: ip,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: const MonitorView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MonitorViewmodel>().clearLogs();
        },
        tooltip: 'Clear Logs',
        child: const Icon(Icons.delete),
      ),
    );
  }
}
