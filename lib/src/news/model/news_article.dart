class NewsArticle {
  final String author;
  final String content;
  final DateTime publishedAt;
  final String title;
  final String description;
  final String url;
  final String imageUrl;


  NewsArticle({required this.author,required this.content,required this.publishedAt,required this.title, required this.description, required this.url, required this.imageUrl});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      author: json['author'] ?? 'Unknown',
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'] ?? '',
    );
  }
}