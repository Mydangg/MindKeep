class Dass21Answer {
  Dass21Answer({
    required this.id,
    required this.text,
    required this.order,
    required this.score,
  });

  factory Dass21Answer.fromJson(Map<String, dynamic> json) {
    return Dass21Answer(
      id: json['id'],
      text: json['text'],
      order: json['order'],
      score: json['score'],
    );
  }
  String id;
  String text;
  int score;
  int order;

  Map<String, dynamic> toJson() {
    return {'text': text, 'order': order, 'score': score};
  }
}
