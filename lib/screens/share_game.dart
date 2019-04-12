import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bloc/bloc.dart';

class ShareGameScreen extends StatelessWidget {
  ShareGameScreen({@required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share the game'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40),
                child: QrImage(data: codeToQr(code), size: 300),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: Text(code, style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
