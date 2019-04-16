part of 'bloc.dart';

Map<String, dynamic> _gameToFirestore(BingoGame game) {
  return {
    'size': game.size,
    'numPlayers': game.numPlayers,
    'labels': game.labels.toList(),
    'polls': game.polls.map(_voteToFirestore).toList(),
    'marked': game.marked.toList(),
  };
}

BingoGame _firestoreToGame(String id, dynamic doc) {
  int numPlayers = doc['numPlayers'];
  return BingoGame(
    id: id,
    size: doc['size'] as int,
    numPlayers: numPlayers,
    labels: Set<String>.from(doc['labels'] as List),
    polls: Set<Poll>.from((doc['polls'] as List).map<Poll>((doc) {
      return _firestoreToPoll(doc, numPlayers);
    })),
    marked: Set<String>.from(doc['marked'] as List),
  );
}

Map<String, dynamic> _voteToFirestore(Poll vote) {
  return {
    'word': vote.word,
    'votesFor': vote.votesApprove,
    'votesAgainst': vote.votesReject,
    'deadline': vote.deadline,
  };
}

Poll _firestoreToPoll(dynamic doc, int numPlayers) {
  return Poll(
    word: doc['word'] as String,
    votesApprove: doc['votesFor'] as int,
    votesReject: doc['votesAgainst'] as int,
    numPlayers: numPlayers,
    deadline: DateTime.fromMicrosecondsSinceEpoch(
        (doc['deadline'] as Timestamp).microsecondsSinceEpoch),
  );
}

String _simpleHash(String input) {
  var hash = 0;
  for (var unit in input.codeUnits) {
    hash = (123 * hash + unit) % 10000;
  }
  return '$hash';
}

String codeToQr(String code) => 'bingo:$code:${_simpleHash(code)}';

String qrToCode(String qr) {
  var invalidError = () => ArgumentError('Not a bingo qr code.');

  if (!qr.startsWith('bingo:')) throw invalidError();

  var startOfCode = qr.indexOf(':') + 1;
  if (startOfCode == -1) throw invalidError();

  var startOfHash = qr.indexOf(':', startOfCode + 1) + 1;
  if (startOfHash == -1) throw invalidError();

  var code = qr.substring(startOfCode, startOfHash - 1);
  var hash = qr.substring(startOfHash);

  if (_simpleHash(code) != hash) throw invalidError();

  return code;
}
