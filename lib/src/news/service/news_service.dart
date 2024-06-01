import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/news_article.dart';

class NewsService {
  final String _apiKey = 'f97975702cc249b4bec38d34bb807148';
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({String category = ''}) async {
    final response = await http.get(Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      Iterable list = result['articles'];
      List<NewsArticle> articles = list
      .map((article) => NewsArticle.fromJson(article))
      .where((article) => article.imageUrl.trim().isNotEmpty)
      .toList();
      return articles;
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}

