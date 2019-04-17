import 'package:flutter/material.dart';

/// A Poll is about a specific word. All the players are asked to confirm
/// whether the word has actually been said by the lecturer or not. The poll
/// ends in either one of these cases:
/// - If >= 50% vote for approving the word, the word is marked on all fields.
/// - If > 50% vote for rejecting the word, the poll gets deleted and nothing
///   happens.
/// - If the deadline runs out without enough players voting, the word gets
///   rejected.
///
/// Important note about comparing Polls: Two polls are considered equal if
/// their word is equal, the number of votes are not considered.
class Poll {
  /// The word that the poll is about.
  final String word;

  /// How many voted for approving or rejecting the word, as well as how many
  /// players there are.
  final int votesApprove, votesReject;
  final int numPlayers;
  int get votesUndecided => numPlayers - votesApprove - votesReject;

  // The deadline for voting.
  final DateTime deadline;

  Poll({
    @required this.word,
    @required this.votesApprove,
    @required this.votesReject,
    @required this.numPlayers,
    @required this.deadline,
  });

  /// Creates a new poll.
  factory Poll.newPoll({@required String word, @required int numPlayers}) {
    return Poll(
      word: word,
      votesApprove: 0,
      votesReject: 0,
      numPlayers: numPlayers,
      deadline: DateTime.now().add(Duration(minutes: 1)),
    );
  }

  /// Returns a copy of the poll, but with one more approval.
  Poll voteFor() => this.copyWith(votesApprove: votesApprove + 1);

  /// Returns a copy of the poll, but with one more rejection.
  Poll voteAgainst() => this.copyWith(votesReject: votesReject + 1);

  // Whether the vote got approved.
  bool get isApproved => votesApprove / numPlayers >= 0.5;

  // Whether the vote got rejected.
  bool get isRejected => votesReject / numPlayers > 0.5;

  // Whether the deadline ran out.
  bool get timedOut => DateTime.now().isAfter(deadline);

  Poll copyWith({
    String word,
    int votesApprove,
    int votesReject,
    int numPlayers,
    DateTime deadline,
  }) {
    return Poll(
      word: word ?? this.word,
      votesApprove: votesApprove ?? this.votesApprove,
      votesReject: votesReject ?? this.votesReject,
      numPlayers: numPlayers ?? this.numPlayers,
      deadline: deadline ?? this.deadline,
    );
  }

  @override
  bool operator ==(other) {
    return other is Poll && other.word == word;
  }

  @override
  int get hashCode => word.hashCode;

  @override
  String toString() {
    return '{$word, $votesApprove vs. $votesReject}';
  }
}
