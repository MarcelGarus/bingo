import 'package:flutter/material.dart';

/// A [Poll] is a decision in progress about whether a specific word was said.
/// All the players are asked to confirm whether the word has actually been
/// said or not. The poll ends in either one of these cases:
/// - If >= 50% approve that the word was said, the poll is approved.
/// - If > 50% deny that the word was said, the poll is rejected.
/// - If the deadline runs out without enough players voting, the poll is
///   rejected.
class Poll {
  final String word;

  /// How many players that can vote there are.
  final int numPlayers;

  /// How many players voted for approving or rejecting the word.
  final int votesApprove, votesReject;
  int get votesUndecided => numPlayers - votesApprove - votesReject;

  // When the vote will be automatically rejected.
  final DateTime deadline;

  Poll({
    @required this.word,
    @required this.numPlayers,
    @required this.votesApprove,
    @required this.votesReject,
    @required this.deadline,
  })  : assert(word != null),
        assert(numPlayers != null),
        assert(numPlayers > 0),
        assert(votesApprove != null),
        assert(votesReject != null),
        assert(votesApprove + votesReject <= numPlayers),
        assert(deadline != null);

  /// Creates a new poll.
  Poll.newPoll({@required String word, @required int numPlayers})
      : this(
          word: word,
          numPlayers: numPlayers,
          votesApprove: 0,
          votesReject: 0,
          deadline: DateTime.now().add(Duration(minutes: 1)),
        );

  /// Returns a copy of the poll, but with one more approval.
  Poll voteFor() => _copyWith(votesApprove: votesApprove + 1);

  /// Returns a copy of the poll, but with one more rejection.
  Poll voteAgainst() => _copyWith(votesReject: votesReject + 1);

  // Whether this poll got approved.
  bool get isApproved => votesApprove / numPlayers >= 0.5;

  // Whether this poll got rejected.
  bool get isRejected => votesReject / numPlayers > 0.5;

  // Whether the deadline ran out.
  bool get timedOut => DateTime.now().isAfter(deadline);

  Poll _copyWith({
    int votesApprove,
    int votesReject,
  }) {
    return Poll(
      word: this.word,
      numPlayers: this.numPlayers,
      votesApprove: votesApprove ?? this.votesApprove,
      votesReject: votesReject ?? this.votesReject,
      deadline: this.deadline,
    );
  }

  @override
  bool operator ==(other) {
    return other is Poll &&
        other.word == word &&
        other.numPlayers == numPlayers &&
        other.votesApprove == votesApprove &&
        other.votesReject == votesReject &&
        other.deadline == deadline;
  }

  @override
  int get hashCode =>
      hashValues(word, numPlayers, votesApprove, votesReject, deadline);

  @override
  String toString() {
    return '($votesApprove|$votesReject|$votesUndecided)';
  }
}
