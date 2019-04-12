import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareGameScreen extends StatelessWidget {
  ShareGameScreen({@required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: QrImage(data: code, size: 200))
    );
  }
}
