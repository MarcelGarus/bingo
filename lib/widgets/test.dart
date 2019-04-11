import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Center(
        child: Text('Hello world.'),
      ),
    );
  }
}
