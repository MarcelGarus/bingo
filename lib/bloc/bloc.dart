import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'models.dart';
import 'streamed_property.dart';

class Bloc {
  StreamedProperty<BingoGame> _game;
  BingoGame get game => _game.value;
  ValueObservable<BingoGame> get gameStream => _game.stream;
  StreamedProperty<BingoField> _field;
  BingoField get field => _field.value;
  ValueObservable<BingoField> get fieldStream => _field.stream;

  // Firestore helpers.
  CollectionReference get _firestoreGames =>
      Firestore.instance.collection('games');
  CollectionReference get _firestorePlayers => Firestore.instance
      .collection('games')
      .document(_game.value.id)
      .collection('players');

  // Loads the game.
  Future<BingoGame> _getGame(id) async {
    var snapshot = await _firestoreGames.document(id).get();
    if (!snapshot.exists) {
      throw StateError("Game doesn't exist."); //GameDoesNotExistError();
    }
    var data = snapshot.data;

    return BingoGame(
      id: id,
      width: data['width'] as int,
      height: data['height'] as int,
      numPlayers: data['numPlayers'] as int,
      labels: Set.from(data['labels'] as List<String>),
      voteQueue: Queue.from(data['voteQueue'] as List<String>),
      marked: Set.from(data['marked'] as List<String>),
    );
  }

  // Loads a player.
  Future<BingoField> _getField(id) async {
    var snapshot = await _firestorePlayers.document(id).get();
    if (!snapshot.exists) {
      throw StateError("Field doesn't exist.");
    }
    var data = snapshot.data;

    return BingoField(
      id: id,
      width: _game.value.width,
      height: _game.value.height,
      tiles: (data['tiles'] as List<String>).map((label) {
        return BingoTile(label, isMarked: _game.value.marked.contains(label));
      }).toList(),
    );
  }

  // Creates a new game.
  Future<void> createGame(int width, int height, Set<String> labels) async {
    var doc = await _firestoreGames.add({
      'width': width,
      'height': height,
      'numPlayers': 0,
      'labels': List.from(labels),
      'voteQueue': [],
      'marked': [],
    });
    _game.value = BingoGame.newGame(
      id: doc.documentID,
      width: width,
      height: height,
      numPlayers: 0,
      labels: labels,
    );
  }

  // Joins a game.
  Future<void> joinGame(String id) async {
    var game = await _getGame(id);
    game = game.copyWith(numPlayers: game.numPlayers + 1);

    await _firestoreGames.document(id).setData({'numPlayers': game.numPlayers});
    _game.value = game;
  }

  // Selects labels.
  Future<void> selectLabels(Set<String> labels) async {
    var doc = await _firestorePlayers.add({
      'tiles': List.from(labels, growable: false),
    });
    _field.value = BingoField.fromLabels(
      id: doc.documentID,
      width: game.width,
      height: game.height,
      labels: labels,
    );
  }

  // Propose a marking to the crowd.
  Future<void> proposeMarking(String label) async {
    var g = game.copyWith(
      voteQueue: game.voteQueue..add(Vote.newVote(label: label)),
    );
    await _firestoreGames.document(g.id).setData({
      'voteQueue': List.from(g.voteQueue),
    }, merge: true);
    _game.value = g;
  }

  // Votes for a label.
  Future<void> voteFor(String label) async {
    var vote = game.getVote(label);
    var g = game.copyWithUpdatedVote(original: vote, updated: vote.voteFor());

    if (vote.isApproved(g.numPlayers)) {
      vote = null;
      g = game.copyWithUpdatedVote(original: vote, updated: null).copyWith(
            marked: g.marked.union({label}),
          );
    }

    // TODO: check if won

    await _firestoreGames.document(g.id).setData({
      'voteQueue': List.from(g.voteQueue),
      'marked': List.from(g.marked),
    }, merge: true);
    _game.value = g;
  }

  // Votes against a label.
  Future<void> voteAgainst(String label) async {
    var vote = game.getVote(label);
    var g =
        game.copyWithUpdatedVote(original: vote, updated: vote.voteAgainst());

    if (vote.isRejected(g.numPlayers)) {
      vote = null;
      g = game.copyWithUpdatedVote(original: vote, updated: null);
    }

    await _firestoreGames.document(g.id).setData({
      'voteQueue': List.from(g.voteQueue),
    }, merge: true);
    _game.value = g;
  }

  void _onUpdated(BingoGame game) {
    // TODO: implement
    /*var f = field.withMarked(label);
    await _firestorePlayers.document(f.id).setData({'tiles': f.tiles});
    _field.value = f;*/
  }

  void _checkIfWon() {}
}
