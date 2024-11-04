import 'package:flutter/material.dart';
import '../model/news_article.dart';
import '../service/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoadingVertical = false;
  bool _isLoadingHorizontal = false;
  String _selectedCategory = ' '; 

  List<NewsArticle> get articles => _filteredArticles;
  bool get isLoadingVertical => _isLoadingVertical;
  bool get isLoadingHorizontal => _isLoadingHorizontal;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchTopHeadlinesHorizontal({required String category}) async {
    _selectedCategory = category; 
    _isLoadingHorizontal=true;
    notifyListeners(); 
    try {
      _articles = await NewsService().fetchTopHeadlines(category: category.trim());
      _filteredArticles = _articles
          .where((article) => !article.title.toLowerCase().contains('removed'))
          .toList();
    } catch (e) {
      print('Hata: $e');
    } finally {
      _isLoadingHorizontal=false;
      notifyListeners(); 
    }
  }

  Future<void> fetchTopHeadlinesVertical({required String category}) async {
    _selectedCategory = category; 
    _isLoadingVertical=true;
    notifyListeners(); 
    try {
      _articles = await NewsService().fetchTopHeadlines(category: category.trim());
      _filteredArticles = _articles
          .where((article) => !article.title.toLowerCase().contains('removed'))
          .toList();
    } catch (e) {
      print('Hata: $e');
    } finally {
    _isLoadingVertical=false;
      notifyListeners(); 
    }
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
  Future<void> refreshNewsVertical() async {
    _isLoadingVertical=true;
    notifyListeners();
    await fetchTopHeadlinesVertical(category: selectedCategory);
    _isLoadingVertical=false;
    notifyListeners();
  }
  Future<void> refreshNewsHorizontal() async {
    _isLoadingHorizontal=true;
    notifyListeners();
    await fetchTopHeadlinesHorizontal(category: selectedCategory);
    _isLoadingHorizontal=false;
    notifyListeners();
  }
}
