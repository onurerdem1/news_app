import 'package:flutter/material.dart';

import '../model/news_article.dart';
import '../service/news_service.dart';


class NewsViewModel extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = false;

  List<NewsArticle> get articles => _filteredArticles;
  bool get isLoading => _isLoading;

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    notifyListeners();

    _articles = await NewsService().fetchTopHeadlines();
    _filteredArticles = _articles;

    _isLoading = false;
    notifyListeners();
  }

  void filterArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles = _articles
          .where((article) => article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
