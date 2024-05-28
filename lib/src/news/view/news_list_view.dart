import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../view_model/news_view_model.dart';
import 'news_detail_view.dart';

class NewsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                Provider.of<NewsViewModel>(context, listen: false).filterArticles(query);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<NewsViewModel>(
              builder: (context, model, child) {
                if (model.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: model.articles.length,
                  itemBuilder: (context, index) {
                    final article = model.articles[index];
                    return ListTile(
                      title: Text(article.title),
                      subtitle: Text(article.description.isNotEmpty ? article.description : 'No Description'),
                      leading: article.imageUrl.isNotEmpty
                          ? Image.network(article.imageUrl, width: 100, fit: BoxFit.cover)
                          : Container(width: 100, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailView(article: article),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
