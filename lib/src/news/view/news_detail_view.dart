import 'package:flutter/material.dart';

import '../model/news_article.dart';


class NewsDetailView extends StatelessWidget {
  final NewsArticle article;

  NewsDetailView({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.imageUrl.isNotEmpty
                ? Image.network(article.imageUrl)
                : Container(height: 200, color: Colors.grey),
            SizedBox(height: 8.0),
            Text(
              article.title,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'By ${article.author}',
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8.0),
            Text(
              'Published at ${article.publishedAt}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            Text(
              article.content,
              style: TextStyle(fontSize: 16.0),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
