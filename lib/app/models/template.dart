import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class GameTemplate {
  final String title;
  final int size;
  final Set<String> words;
  final DateTime lastUsed;

  GameTemplate({
    @required this.title,
    @required this.size,
    @required this.words,
    @required this.lastUsed,
  })  : assert(title != null),
        assert(size != null),
        assert(words != null);

  factory GameTemplate.fromJson(Map<String, dynamic> data) {
    return GameTemplate(
      title: data['title'],
      size: data['size'],
      words: data['words'],
      lastUsed: data['lastUsed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'size': size,
      'words': words,
      'lastUsed': lastUsed,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is GameTemplate &&
        title == other.title &&
        size == other.size &&
        words == other.words &&
        lastUsed == other.lastUsed;
  }

  @override
  int get hashCode => hashValues(title, size, words, lastUsed);
}

Future<Set<GameTemplate>> loadTemplates() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return (prefs.getStringList('templates') ?? [])
      .map((string) => GameTemplate.fromJson(jsonDecode(string)))
      .toSet();
}

Future<void> saveTemplate(Set<GameTemplate> templates) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('templates', templates.map(jsonEncode).toList());
}
