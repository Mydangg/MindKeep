class Article {

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.tags,
    required this.author,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.liked,
    required this.saved,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      author: json['author'],
      source: json['source'],
      publishedAt: DateTime.parse(json['publishedAt']),
      imageUrl: json['imageUrl'],
      liked: json['liked'],
      saved: json['saved'],
    );
  }
  final int id;
  final String title;
  final String description;
  final String content;
  final List<String> tags;
  final String author;
  final String source;
  final DateTime publishedAt;
  final String imageUrl;
  bool liked;
  bool saved;
}
