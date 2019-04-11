part of 'bloc.dart';

Map<String, dynamic> _gameToFirestore(BingoGame game) {
  return {
    'size': game.size,
    'numPlayers': game.numPlayers,
    'labels': List.from(game.labels),
    'voteQueue': List.from(game.votes),
    'marked': List.from(game.marked),
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
