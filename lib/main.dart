import 'package:dart_mq/dart_mq.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_monitor/local_server.dart';
import 'package:mobile_monitor/models/Response.dart';
import 'package:mobile_monitor/utils/qr_utils.dart';
import 'package:mobile_monitor/viewmodels/monitor_call_stack_viewmodel.dart';
import 'package:mobile_monitor/views/monitor_call_stack_item.dart';
import 'package:provider/provider.dart';

import 'apis.dart';

void main() {
  MQClient.initialize();
  MQClient.instance.declareQueue(monitorCallStack);
  runApp(const MyApp());
  LocalServer().start();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MonitorCallStackViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ConsumerMixin {
  late LocalServer _server;

  @override
  void initState() {
    final vm = context.read<MonitorCallStackViewModel>();
    super.initState();
    _server = LocalServer();
    _server.start().then((value) => setState(() {}));
    subscribe(
        queueId: monitorCallStack,
        callback: (payload) {
          final response = Response.from(payload);
          switch (response.type) {
            case OperationType.push:
              final oneCallBeans = response.value;
              if (oneCallBeans.isNotEmpty) {
                setState(() {
                  vm.push(oneCallBeans[0]);
                });
              }
              break;
            case OperationType.pop:
              setState(() {
                vm.pop();
              });
              break;
            case OperationType.addAll:
              final oneCallBeans = response.value;
              if (oneCallBeans.isNotEmpty) {
                setState(() {
                  vm.addAll(oneCallBeans);
                });
              }
              break;
            case OperationType.load:
              final oneCallBeans = response.value;
              if (oneCallBeans.isNotEmpty) {
                setState(() {
                  vm.load(oneCallBeans);
                });
              }
              break;
            case OperationType.clear:
              setState(() {
                vm.clear();
              });
              break;
            case OperationType.showToast:
              final info = response.extra as String?;
              if (null != info) {
                Fluttertoast.showToast(
                  msg: info,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  backgroundColor: Colors.red,
                  fontSize: 14.0,
                );
              }
              break;
            case _:
              break;
          }
        });
  }

  @override
  void dispose() {
    _server.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MonitorCallStackViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_server.wifiIP),
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
                            ip: _server.wifiIP,
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
      body: Center(
        child: ListView.builder(
          itemCount: vm.oneCallBeans.length,
          itemBuilder: (_, index) {
            final item = vm.oneCallBeans[index];
            return MonitorCallStackItem(
              name: item.name,
              color: item.color,
            );
          },
        ),
      ),
    );
  }
}
