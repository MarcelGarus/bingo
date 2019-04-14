import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';
import 'models.dart';
import 'streamed_property.dart';

export 'models.dart';

part 'parsers.dart';

class Bloc {
  final _game = StreamedProperty<BingoGame>();
  BingoGame get game => _game.value;
  ValueObservable<BingoGame> get gameStream => _game.stream;

  final _field = StreamedProperty<BingoField>();
  ValueObservable<BingoField> get fieldStream => _field.stream;

  final _votedWords = <String>{};
  Set<String> get wordsToVoteFor =>
      game.votes.map((v) => v.label).toSet().difference(_votedWords);

  // Firestore helpers.
  CollectionReference get _firestoreGames =>
      Firestore.instance.collection('games');

  /// This method allows subtree widgets to access this bloc.
  static Bloc of(BuildContext context) {
    assert(context != null);
    final BlocProvider holder = context.ancestorWidgetOfExactType(BlocProvider);
    return holder?.bloc;
  }

  Future<void> dispose() async {
    await _game.dispose();
    await _field.dispose();
  }

  /// Loads the game.
  Future<BingoGame> _getGame(String id) async {
    var snapshot = await _firestoreGames.document(id).get();
    if (!snapshot.exists) {
      throw StateError("Game doesn't exist."); //GameDoesNotExistError();
    }
    return _firestoreToGame(id, snapshot.data);
  }

  /// Creates a new game.
  Future<void> createGame({
    @required int size,
    @required Set<String> labels,
  }) async {
    // Create a new game with the given size and labels.
    var game = BingoGame.newGame(size: size, numPlayers: 1, labels: labels);

    // Add the game to Firestore. If that succeeded, add it to the UI stream.
    var doc = await _firestoreGames.add(_gameToFirestore(game));
    _game.value = game.copyWith(id: doc.documentID);
  }

  /// Joins a game.
  Future<void> joinGame(String id) async {
    // Get the game and update its number of players.
    var game = (await _getGame(id));
    game = game.copyWith(numPlayers: game.numPlayers + 1);

    // Add the game to Firestore. If that succeeded, add it to the UI stream.
    await _firestoreGames.document(id).setData(_gameToFirestore(game));
    _game.value = game;
  }

  /// Selects labels.
  Future<void> selectLabels(Set<String> labels) async {
    // Create a field and add it to the UI stream.
    _field.value = BingoField.fromLabels(size: game.size, labels: labels);

    // From now on, subscribe to updates to the game and update the field
    // accordingly.
    _firestoreGames.document(game.id).snapshots().listen((snapshot) {
      _onUpdate(_firestoreToGame(snapshot.documentID, snapshot.data));
    });
  }

  void _onUpdate(BingoGame game) {
    _field.value = _field.value.withTileStates((label) {
      if (game.marked.contains(label)) {
        return BingoTileState.marked;
      } else if (game.votes.any((vote) => vote.label == label)) {
        return BingoTileState.voting;
      } else {
        return BingoTileState.unmarked;
      }
    });
    _game.value = game;
  }

  // Propose a marking to the crowd.
  Future<void> proposeMarking(String label) async {
    _game.value = game.copyWith(
      votes: game.votes..add(Vote.newVote(label: label)),
    );
    await voteFor(label);
  }

  // Votes for a label.
  Future<void> voteFor(String label) async {
    _votedWords.add(label);
    var vote = game.getVote(label);
    var upvoted = vote.voteFor();
    var g = game.copyWithUpdatedVote(original: vote, updated: upvoted);

    if (upvoted.isApproved(g.numPlayers)) {
      g = game.copyWithUpdatedVote(original: vote, updated: null).copyWith(
            marked: g.marked.union({label}),
          );
    }

    await _firestoreGames.document(g.id).setData({
      'voteQueue': g.votes.map(_voteToFirestore).toList(),
      'marked': g.marked.toList(),
    }, merge: true);
    _game.value = g;
    _onUpdate(g);

    // TODO: check if won?
  }

  // Votes against a label.
  Future<void> voteAgainst(String label) async {
    _votedWords.add(label);
    var vote = game.getVote(label);
    var g =
        game.copyWithUpdatedVote(original: vote, updated: vote.voteAgainst());

    if (vote.isRejected(g.numPlayers)) {
      vote = null;
      g = game.copyWithUpdatedVote(original: vote, updated: null);
    }

    await _firestoreGames.document(g.id).setData({
      'voteQueue': g.votes.map(_voteToFirestore).toList(),
    }, merge: true);
    _game.value = g;
    _onUpdate(g);
  }
}
