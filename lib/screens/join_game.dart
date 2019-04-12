import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bloc/bloc.dart';
import '../screens/select_words.dart';
import '../widgets/bold_buttons.dart';
import '../widgets/bold_input.dart';

class JoinGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: MediaQuery.of(context).padding +
            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: _GameCodeInput(),
      ),
    );
  }
}

class _GameCodeInput extends StatefulWidget {
  @override
  _GameCodeInputState createState() => _GameCodeInputState();
}

class _GameCodeInputState extends State<_GameCodeInput> {
  _showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _joinGame(String code) async {
    try {
      await Bloc.of(context).joinGame(code);
    } on StateError catch (e) {
      _showSnackBar("Couldn't find the game with code $code.");
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => SelectWordsScreen(),
    ));
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: Text('Join a game', style: TextStyle(fontSize: 32))),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: HoveredInput(hint: 'Enter the code', onDone: _joinGame),
        ),
        SizedBox(height: 16),
        Text('or', style: TextStyle(color: Colors.black54)),
        SizedBox(height: 16),
        BoldRaisedButton(
          label: 'Scan QR code',
          color: Colors.red,
          onPressed: scan,
        ),
      ],
    );
  }

  Future scan() async {
    try {
      String qr = await BarcodeScanner.scan();
      _joinGame(qrToCode(qr));
    } on ArgumentError catch (_) {
      _showSnackBar(
          "That doesn't look like a valid game code... Perhaps try again?");
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showSnackBar('You need to grant camera permissions to scan the code.');
      } else {
        _showSnackBar('Unknown error: $e');
      }
    } on FormatException {
      // User returned using the back button before scanning anything.
    } catch (e) {
      _showSnackBar('Unknown error: $e');
    }
  }
}
