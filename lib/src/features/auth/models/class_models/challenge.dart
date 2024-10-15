class Challenge {
  final String question;
  final String answer;
  final String answerType;

  Challenge({
    required this.question,
    required this.answer,
    required this.answerType,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      question: json['question'],
      answer: json['answer'],
      answerType: json['answerType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'answerType': answerType,
    };
  }
}