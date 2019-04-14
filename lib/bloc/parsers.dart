part of 'bloc.dart';

Map<String, dynamic> _gameToFirestore(BingoGame game) {
  return {
    'size': game.size,
    'numPlayers': game.numPlayers,
    'labels': game.labels.toList(),
    'voteQueue': game.votes.map(_voteToFirestore).toList(),
    'marked': game.marked.toList(),
  };
}

BingoGame _firestoreToGame(String id, dynamic doc) {
  return BingoGame(
    id: id,
    size: doc['size'] as int,
    numPlayers: doc['numPlayers'] as int,
    labels: Set<String>.from(doc['labels'] as List),
    votes:
        Set<Vote>.from((doc['voteQueue'] as List).map<Vote>(_firestoreToVote)),
    marked: Set<String>.from(doc['marked'] as List),
  );
}

Map<String, dynamic> _voteToFirestore(Vote vote) {
  return {
    'label': vote.label,
    'votesFor': vote.votesFor,
    'votesAgainst': vote.votesAgainst,
  };
}

Vote _firestoreToVote(dynamic doc) {
  return Vote(
    label: doc['label'] as String,
    votesFor: doc['votesFor'] as int,
    votesAgainst: doc['votesAgainst'] as int,
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
