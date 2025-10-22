
// Poll Models
class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  bool hasVoted;
  int? selectedOptionIndex;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    this.hasVoted = false,
    this.selectedOptionIndex,
  });
}

class PollOption {
  final String text;
  int votes;

  PollOption({required this.text, this.votes = 0});

  double getPercentage(int totalVotes) {
    if (totalVotes == 0) return 0;
    return (votes / totalVotes) * 100;
  }
}