import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../category.dart';
import '../view_model/news_view_model.dart';
import 'news_detail_view.dart';

class NewsListView extends StatefulWidget {
  final VoidCallback onToggleTheme;
  NewsListView({required this.onToggleTheme});
  @override
  _NewListViewState createState() => _NewListViewState();
}

class _NewListViewState extends State<NewsListView>{
  bool _isSearching = false;
  TextEditingController searchcontroller = TextEditingController();
  final List<Category> categories = [
    Category(name: 'Top Headlines', code: ' '),
    Category(name: 'Business', code: 'business'),
    Category(name: 'Entertainment', code: 'entertainment'),
    Category(name: 'Health', code: 'health'),
    Category(name: 'Science', code: 'science'),
    Category(name: 'Sports', code: 'sports'),
    Category(name: 'Technology', code: 'technology'),
  ];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<NewsViewModel>(context,listen: false).fetchTopHeadlines();
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
        title: !_isSearching
          ? Text("News App")
        : TextField(
          onChanged: (query){
            Provider.of<NewsViewModel>(context,listen: false).filterArticles(query);
          },
          controller: searchcontroller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                setState(() {
                  searchcontroller.clear();
                  _isSearching=false;
                });
              },
            ),
            hintText: "Search...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
              prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: _buildAppBarActions(),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      ),
      body: Column(
        children: [
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

                return RefreshIndicator(
                onRefresh: model.refreshNews,
                  child : ListView.builder(
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
                )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> _buildAppBarActions() {
    if(!_isSearching){
      return [
        IconButton(
          onPressed: (){
            setState(() {
              _isSearching=true;
            });
          },
          icon: Icon(Icons.search)
        ),
        IconButton(
          onPressed: (){
            widget.onToggleTheme();
          },
          icon: Icon(Icons.brightness_6),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset("assets/splash/splash_icon.png",width: 40,height: 40,),
        )
      ];
    }
    else {
      return [
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset("assets/splash/splash_icon.png",width: 40,height: 40,),
      ),
    Container()
    ];
    }
  }



}



