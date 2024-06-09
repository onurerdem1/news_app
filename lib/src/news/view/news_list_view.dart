import 'package:flutter/material.dart';
import 'package:news_app/core/image/image_constants.dart';
import 'package:news_app/src/news/model/news_article.dart';
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
    return Scaffold(
       appBar: appBAr(context),
      body: Column(
        children: [
          buildCategories(context),
          buildNews(context),
        ],
      ),
    );
  }

  Widget buildArticleCard(BuildContext context,NewsArticle article){
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          navigatetoDetail(context, article);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(article.imageUrl),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                article.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                article.description ,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Published at : ${article.publishedAt}',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget buildNews(BuildContext context){
    return Expanded(
      child: Consumer<NewsViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (model.articles.isEmpty){
            return Center(child: Text("No Articles Available."),);
          }
          return RefreshIndicator(
              onRefresh: model.refreshNews,
              child : ListView.builder(
                itemCount: model.articles.length,
                itemBuilder: (context, index) {
                  final article = model.articles[index];
                  return buildArticleCard(context, article);
                },
              )
          );
        },
      ),
    );
  }

  Widget buildCategories(BuildContext context){
    return SingleChildScrollView(
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
    );
  }

  PreferredSize appBAr(BuildContext context){
    final theme = Theme.of(context);
    return PreferredSize(
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
          child: Image.asset(ImageConstants.instance.splashIcon,width: 40,height: 40,),
        )
      ];
    }
    else {
      return [
        Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset(ImageConstants.instance.splashIcon,width: 40,height: 40,),
      ),
    Container()
    ];
    }
  }

  void navigatetoDetail(BuildContext context,NewsArticle article){
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation)=> NewsDetailView(article: article),
          transitionsBuilder: (context,animation,secondaryAnimation,child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin,end: end,).chain(CurveTween(curve: curve));

            return SlideTransition(
            position: animation.drive(tween),
            child: child,
            );

          }

      )
    );
  }



}



