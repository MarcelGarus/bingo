import 'package:flutter/material.dart';

class NewGameScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        padding: MediaQuery.of(context).padding +
            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        children: <Widget>[
          Center(
            child: Text('Create a new game', style: TextStyle(fontSize: 32)),
          ),
          SizedBox(height: 16),
          Wrap(
            children: ['hey', 'you', 'lovely', 'day']
                .map((t) {
                  return Chip(
                    label: Text(t),
                    backgroundColor: Colors.white,
                    elevation: 2,
                    onDeleted: () {},
                  );
                })
                .expand((c) => [c, SizedBox(width: 8)])
                .toList(),
          ),
          SizedBox(height: 16),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a new word',
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.play_arrow),
        label: Text('Start the game'),
        backgroundColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
