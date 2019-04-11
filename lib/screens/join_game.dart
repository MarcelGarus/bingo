import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bloc/bloc.dart';
import '../screens/select_words.dart';
import '../widgets/hovered_input.dart';

class JoinGameScreen extends StatefulWidget {
  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  String barcode;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        padding: MediaQuery.of(context).padding +
            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        children: <Widget>[
          Center(
            child: Text('Join a game', style: TextStyle(fontSize: 32)),
          ),
          SizedBox(height: 16),
          HoveredInput(
            hint: 'Enter the code',
            onDone: (code) async {
              await Bloc.of(context).joinGame(code);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SelectWordsScreen(),
              ));
            },
          ),
          RaisedButton(child: Text(barcode ?? 'Scan qr code'), onPressed: scan),
        ],
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
