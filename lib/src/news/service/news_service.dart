import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/src/news/model/news_article.dart';

class NewsService {
  final String _apiKey = 'f97975702cc249b4bec38d34bb807148';
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({String category = ''}) async {
    try {
      final url = '$_baseUrl/top-headlines?country=us${category.isNotEmpty ? '&category=$category' : ''}&apiKey=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        Iterable list = result['articles'];
        List<NewsArticle> articles = [];
        for (var article in list) {
          final newsArticle = NewsArticle.fromJson(article);
          final imageUrl = newsArticle.imageUrl;
          if (imageUrl.trim().isNotEmpty) {
            final imageResponse = await http.head(Uri.parse(imageUrl));
            if (imageResponse.statusCode != 406) {
              articles.add(newsArticle);
            }
          }
        }
        return articles;
      } else {
        throw Exception('Failed to load top headlines');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
