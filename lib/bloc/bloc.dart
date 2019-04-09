import 'package:rxdart/rxdart.dart';

import 'models.dart';
import 'streamed_property.dart';

class Bloc {
  StreamedProperty<BingoField> _field;
  ValueObservable<BingoField> get fieldStream => _field.stream;

  // Creates a new game.
  void createGame(int width, int height, Set<String> labels) {}
}
