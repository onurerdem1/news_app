import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../category.dart';
import '../view_model/news_view_model.dart';
import 'news_detail_view.dart';


class NewsListView extends StatelessWidget {
  final List<Kategory> categories = [
    Kategory(name: 'Top Headlines', code: ' '),
    Kategory(name: 'Business', code: 'business'),
    Kategory(name: 'Entertainment', code: 'entertainment'),
    Kategory(name: 'Health', code: 'health'),
    Kategory(name: 'Science', code: 'science'),
    Kategory(name: 'Sports', code: 'sports'),
    Kategory(name: 'Technology', code: 'technology'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        backgroundColor: Colors.grey[200],
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<NewsViewModel>(context, listen: false)
                        .fetchTopHeadlines(category: category.code);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: category.code == Provider.of<NewsViewModel>(context).selectedCategory
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      category.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailView(article: article),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            article.imageUrl.isNotEmpty
                                ? Image.network(article.imageUrl, fit: BoxFit.cover)
                                : Container(height: 50, color: Colors.grey,child: Center(child: Text("No Image"),),),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    article.description.isNotEmpty ? article.description : 'No Description',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Published at ${article.publishedAt}',
                                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
