import 'package:flutter/material.dart';
import '../model/news_article.dart';
import '../service/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  bool _isLoading = false;
  String _selectedCategory = ' '; // Başlangıç olarak 'Top Headlines' kategorisi

  List<NewsArticle> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchTopHeadlines({required String category}) async {
    _selectedCategory = category; // Seçilen kategoriyi güncelle
    _isLoading = true; // Yükleniyor durumunu güncelle
    notifyListeners(); // Ekranı güncelle

    try {
      // Servis çağrısını gerçekleştir ve "removed" başlığı olan makaleleri filtrele
      _articles = await NewsService().fetchTopHeadlines(category: category.trim());
      _filteredArticles = _articles
          .where((article) => !article.title.toLowerCase().contains('removed'))
          .toList();
    } catch (e) {
      print('Hata: $e');
    } finally {
      _isLoading = false; // Yüklenme durumu bitti
      notifyListeners(); // Durum değişikliğini bildir
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
  Future<void> refreshNews() async {
    await fetchTopHeadlines(category: selectedCategory);
  }
}
