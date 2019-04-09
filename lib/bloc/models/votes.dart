import 'package:flutter/material.dart';

class Vote {
  final String label;
  final int votesFor, votesAgainst;

  Vote({
    @required this.label,
    @required this.votesFor,
    @required this.votesAgainst,
  });

  factory Vote.newVote({@required String label}) {
    return Vote(label: label, votesFor: 0, votesAgainst: 0);
  }

  Vote voteFor() {
    return Vote(
      label: label,
      votesFor: votesFor + 1,
      votesAgainst: votesAgainst,
    );
  }

  Vote voteAgainst() {
    return Vote(
      label: label,
      votesFor: votesFor,
      votesAgainst: votesAgainst + 1,
    );
  }

  bool isApproved(int numTotalPlayers) => votesFor / numTotalPlayers >= 0.5;

  bool isRejected(int numTotalPlayers) => votesAgainst / numTotalPlayers > 0.5;
}
