import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';
import 'models.dart';
import 'streamed_property.dart';

export 'models.dart';

part 'parsers.dart';

class Bloc {
  final _templates = StreamedProperty<Set<GameTemplate>>();
  Set<GameTemplate> get templates => _templates.value;
  ValueObservable<Set<GameTemplate>> get templatesStream => _templates.stream;

  final _game = StreamedProperty<BingoGame>();
  BingoGame get game => _game.value;
  ValueObservable<BingoGame> get gameStream => _game.stream;

  final _field = StreamedProperty<BingoField>();
  ValueObservable<BingoField> get fieldStream => _field.stream;

  final _votedWords = <String>{};
  Set<String> get wordsToVoteFor =>
      game.polls.map((v) => v.word).toSet().difference(_votedWords);

  // Firestore helpers.
  CollectionReference get _firestoreGames =>
      Firestore.instance.collection('games');

  /// This method allows subtree widgets to access this bloc.
  static Bloc of(BuildContext context) {
    assert(context != null);
    final BlocProvider holder = context.ancestorWidgetOfExactType(BlocProvider);
    return holder?.bloc;
  }

  Bloc() {
    () async {
      _templates.value = await loadTemplates();
    }();
  }

  Future<void> dispose() async {
    if (game != null) leaveGame();
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
  Future<void> createGame({@required GameTemplate template}) async {
    // Create a new game with the given size and labels.
    var game = BingoGame.newGame(numPlayers: 1, template: template);

    // Add the game to Firestore. If that succeeded, add it to the UI stream.
    var doc = await _firestoreGames.add(_gameToFirestore(game));
    _game.value = game.copyWith(id: doc.documentID);
  }

  /// Joins a game.
  Future<void> joinGame(String id) async {
    // Get the game and update its number of players.
    var game = (await _getGame(id));
    game = game.copyWith(numPlayers: game.numPlayers + 1);

    // Update the game in Firestore. If that succeeded, add it to the UI stream.
    await _firestoreGames.document(id).setData(_gameToFirestore(game));
    _game.value = game;

    // Save the template if it's not there already.
    var template = GameTemplate(
      title: game.title,
      size: game.size,
      words: game.words,
      lastUsed: DateTime.now(),
    );
    int suffix = 1;
    var title;
    if (templates.any((d) {
      title = suffix == 1 ? template.title : '${template.title} ($suffix)';
      return d.title == title &&
          d.words == template.words &&
          d.size == template.size;
    })) suffix++;
  }

  /// Leaves a game.
  Future<void> leaveGame() async {
    // Get the game and update its number of players.
    var game = (await _getGame(this.game.id));
    game = game.copyWith(numPlayers: game.numPlayers - 1);

    // Update the game in Firestore. Either way, remove the game.
    await _firestoreGames
        .document(this.game.id)
        .setData(_gameToFirestore(game));
    _game.value = null;
  }

  /// Selects labels.
  Future<void> selectLabels(Set<String> labels) async {
    // Create a field and add it to the UI stream.
    _field.value = BingoField.fromWords(size: game.size, words: labels);

    // From now on, subscribe to updates to the game and update the field
    // accordingly.
    _firestoreGames.document(game.id).snapshots().listen((snapshot) {
      _onUpdate(_firestoreToGame(snapshot.documentID, snapshot.data));
    });
  }

  void _onUpdate(BingoGame game) {
    _field.value = _field.value.withUpdatedTiles((tile) {
      var word = tile.word;

      // If the game contains the word in the list of marked words, the tile is
      // marked.
      if (game.marked.contains(word)) {
        return BingoTile.marked(word);
      }

      // If there exists a voting about the word, the tile is being voted on.
      var poll = game.polls
          .singleWhere((poll) => poll.word == word, orElse: () => null);
      if (poll != null) {
        return BingoTile.polled(word, poll);
      }

      // Otherwise, the tile is unmarked.
      return BingoTile.unmarked(word);
    });
    _game.value = game;
  }

  // Propose a marking to the crowd.
  Future<void> proposeMarking(String label) async {
    _game.value = game.copyWith(
      polls: game.polls
        ..add(Poll.newPoll(
          word: label,
          numPlayers: game.numPlayers,
        )),
    );
    await voteFor(label);
  }

  // Votes for a label.
  Future<void> voteFor(String label) async {
    _votedWords.add(label);
    var vote = game.getPoll(label);
    var upvoted = vote.voteFor();
    var g = game.copyWithUpdatedPoll(original: vote, updated: upvoted);

    if (upvoted.isApproved) {
      g = game.copyWithUpdatedPoll(original: vote, updated: null).copyWith(
            marked: g.marked.union({label}),
          );
    }

    await _firestoreGames.document(g.id).setData({
      'polls': g.polls.map(_voteToFirestore).toList(),
      'marked': g.marked.toList(),
    }, merge: true);
    _game.value = g;
    _onUpdate(g);

    // TODO: check if won?
  }

  // Votes against a label.
  Future<void> voteAgainst(String label) async {
    _votedWords.add(label);
    var vote = game.getPoll(label);
    var g =
        game.copyWithUpdatedPoll(original: vote, updated: vote.voteAgainst());

    if (vote.isRejected) {
      vote = null;
      g = game.copyWithUpdatedPoll(original: vote, updated: null);
    }

    await _firestoreGames.document(g.id).setData({
      'polls': g.polls.map(_voteToFirestore).toList(),
    }, merge: true);
    _game.value = g;
    _onUpdate(g);
  }
}
