import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/news_article.dart';
import '../service/news_service.dart';


class NewsViewModel extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = false;
  String _selectedCategory = '';

  List<NewsArticle> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchTopHeadlines({String category = ''}) async {
    _isLoading = true;
    notifyListeners();


    // removed articles should not show up
    try {
      _articles = await NewsService().fetchTopHeadlines(category: category.isEmpty ? '' : category);
      _filteredArticles = _articles.where((article) => !article.title.toLowerCase().contains('removed')).toList();
      _selectedCategory = category;
    } catch (e) {
      print(e);
    }

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
