import 'dart:convert';
import 'dart:io';

import 'models.dart';

final Codec<Game, String> gameCodec =
    _GameJsonCodec().fuse(json).fuse(utf8).fuse(gzip).fuse(_UrlSafeBase64());

/// The [base64] codec is great for encoding bytes into strings using all
/// letters, numbers, + and /. However, in URLs, no slashes are allowed. So,
/// the [_UrlSafeBase64] uses _ instead of /.
class _UrlSafeBase64 extends Codec<List<int>, String> {
  @override
  Converter<List<int>, String> get encoder => _UrlSafeBase64Encoder();

  @override
  Converter<String, List<int>> get decoder => _UrlSafeBase64Decoder();
}

class _UrlSafeBase64Encoder extends Converter<List<int>, String> {
  @override
  String convert(List<int> input) => base64.encode(input).replaceAll('/', '_');
}

class _UrlSafeBase64Decoder extends Converter<String, List<int>> {
  @override
  List<int> convert(String input) => base64.decode(input.replaceAll('_', '/'));
}

/// Converts a [Game] to [json].
class _GameJsonCodec extends Codec<Game, Object> {
  @override
  Converter<Object, Game> get decoder => _JsonToGameConverter();

  @override
  Converter<Game, Object> get encoder => _GameToJsonConverter();
}

class _GameToJsonConverter extends Converter<Game, Object> {
  @override
  Object convert(Game game) {
    return {
      'version': 0,
      'name': game.name,
      'size': game.size,
      'tiles': game.tiles,
    };
  }
}

class _JsonToGameConverter extends Converter<Object, Game> {
  @override
  Game convert(Object data) {
    final json = data as Map<String, dynamic>;
    if (json['version'] < 0) throw 'invalid version';
    switch (json['version']) {
      case 0:
        return Game(
          name: json['name'],
          size: json['size'],
          tiles: (json['tiles'] as List).cast<String>(),
        );
      default:
        throw 'unknown encoding';
    }
  }
}
