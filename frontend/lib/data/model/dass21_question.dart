class Dass21Question {
  Dass21Question({
    required this.id,
    required this.content,
    required this.order,
    required this.type,
  });

  factory Dass21Question.fromJson(Map<String, dynamic> json) {
    return Dass21Question(
      id: json['id'],
      content: json['content'],
      order: json['order'],
      type: json['type'],
    );
  }
  String id;
  String content;
  int order;
  String type;

  Map<String, dynamic> toJson() {
    return {'content': content, 'order': order, 'type': type};
  }
}
