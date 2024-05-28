import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/news_article.dart';

class NewsService {
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  final String _apiKey = 'f97975702cc249b4bec38d34bb807148';

  Future<List<NewsArticle>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse('$_baseUrl?country=us&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      Iterable list = result['articles'];
      return list.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}