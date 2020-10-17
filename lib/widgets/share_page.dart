import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../codec.dart';
import '../models.dart';

class SharePage extends StatefulWidget {
  SharePage({@required this.game});

  final Game game;

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  String url;

  @override
  void initState() {
    super.initState();
    final safeName = widget.game.name.characters
        .map((char) {
          if ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-'
              .contains(char)) {
            return char;
          }
          if (char == ' ') return '-';
          return null;
        })
        .where((char) => char != null)
        .join();
    final encoded = gameCodec.encode(widget.game);
    url = 'https://textbingo.marcelgarus.dev/play/$safeName-$encoded';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share the game', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40),
              child: QrImage(
                data: url.substring(100),
                size: 300,
                version: 10,
                onError: print,
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy),
                  SizedBox(width: 8),
                  Text('Copy link'),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                url,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
