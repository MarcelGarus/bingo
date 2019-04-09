import 'package:rxdart/rxdart.dart';

import 'models.dart';
import 'streamed_property.dart';

class Bloc {
  StreamedProperty<BingoField> _field;
  ValueObservable<BingoField> get fieldStream => _field.stream;
}
