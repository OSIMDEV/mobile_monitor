import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrView extends StatefulWidget {
  final String ip;

  const QrView({
    super.key,
    this.ip = 'localhost',
  });

  @override
  State<StatefulWidget> createState() => QrViewState();
}

class QrViewState extends State<QrView> {
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    final qrCode = QrCode(8, QrErrorCorrectLevel.H)..addData(widget.ip);
    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) => PrettyQrView(
        qrImage: qrImage,
        decoration: const PrettyQrDecoration(),
      );
}
