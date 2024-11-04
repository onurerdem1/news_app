import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/core/colors/colors.dart';
import 'package:news_app/core/image/image_constants.dart';
import 'package:news_app/src/news/model/news_article.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../view_model/news_view_model.dart';
import 'news_detail_view.dart';

class NewsListView extends StatefulWidget {
  final VoidCallback onToggleTheme;
  NewsListView({required this.onToggleTheme});
  @override
  _NewListViewState createState() => _NewListViewState();
}

class _NewListViewState extends State<NewsListView> {
  PageController pageController2 = PageController();
  PageController pageController1 = PageController();
  bool _isSearching = false;
  TextEditingController searchcontroller = TextEditingController();
  final List<Category> categories = [
    Category(name: 'Top Headlines', code: ' ',icon: FontAwesomeIcons.globe),
    Category(name: 'Business', code: 'business',icon: FontAwesomeIcons.building),
    Category(name: 'Entertainment', code: 'entertainment',icon: FontAwesomeIcons.film),
    Category(name: 'Health', code: 'health',icon: FontAwesomeIcons.heartPulse),
    Category(name: 'Science', code: 'science',icon: FontAwesomeIcons.flask),
    Category(name: 'Sports', code: 'sports',icon: FontAwesomeIcons.futbol),
    Category(name: 'Technology', code: 'technology',icon: FontAwesomeIcons.microchip),
  ];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlinesVertical(category: ' ');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlinesHorizontal(category: ' ');
    });
  }

  void dispose(){
    pageController1.dispose();
    pageController2.dispose();
    dispose();
  }

  String timeAgo(DateTime publishedAt){
    final currentDate = DateTime.now();
    final difference = currentDate.difference(publishedAt);
    if (difference.inMinutes < 1) {
    return "Now";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} Minutes Ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} Hours Ago";
  } else {
    return "${difference.inDays} Days Ago";
  }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: appBAr(context, theme.scaffoldBackgroundColor),
      drawer: buildDrawer(context),
      body: Column(
        children: [
          buildCategories(context),
          SizedBox(height: 30,),
          textLine(context,"News Today"),
          SizedBox(height: 15,),
          buildNewsHorizontal(context),
          SizedBox(height: 15,),
          textLine(context, "Latest News"),
          SizedBox(height: 15,),
          buildNewsVertical(context)
        ],
      ),
    );
  }

  Widget textLine(BuildContext context,String text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(padding: EdgeInsets.only(left: 10),
        child : Text("$text",style: TextStyle(fontFamily:"Montserrat" ,fontSize: 22,fontWeight: FontWeight.bold,),),),
        Padding(padding: EdgeInsets.only(right: 20),
        child:Icon(Icons.menu))
      ],
    );
  }

  Widget buildSmallArticleCard(BuildContext context, NewsArticle article) {
  final theme = Theme.of(context);
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    shadowColor: Colors.black,
    elevation: 4,
    color: theme.scaffoldBackgroundColor,
    margin: EdgeInsets.all(10),
    child: InkWell(
      onTap: () {
        navigatetoDetail(context, article);
      },
      child: Padding(
        padding: EdgeInsets.all(8), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                article.imageUrl,
                width: 100, 
                height: 100, 
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis, 
                  ),
                  Padding(padding: EdgeInsets.only(left:170,top: 30),
                  child:Text(
                    timeAgo(article.publishedAt),
                  ))
                  
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget buildArticleCard(BuildContext context, NewsArticle article) {
  final theme = Theme.of(context);
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    shadowColor: Colors.black,
    elevation: 4,
    color: theme.scaffoldBackgroundColor,
    margin: EdgeInsets.all(10),
    child: InkWell(
      onTap: () {
        navigatetoDetail(context, article);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  article.imageUrl,
                  width: double.infinity,
                  height: 150, 
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    timeAgo(article.publishedAt), 
                    style: TextStyle(color: Colors.white, fontSize: 13,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              article.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}




  Widget buildNewsHorizontal(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Consumer<NewsViewModel>(
        builder: (context, model, child) {
          if (model.isLoadingHorizontal) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
          }
          final DateTime now = DateTime.now();
          final List<NewsArticle> recentArticles = model.articles.where((article) {
            return article.publishedAt.isAfter(now.subtract(Duration(days: 2)));
          }).toList();
          if(recentArticles.isEmpty){
            return Center(child: Text("No Articles Available from last 24 Hours"),);
          }

          final List<NewsArticle> horizontalArticles = recentArticles.take(10).toList();
          return RefreshIndicator(
              onRefresh: model.refreshNewsHorizontal,
              child: PageView.builder(
                controller: pageController1,
                itemCount: horizontalArticles.length,
                itemBuilder: (context, index) {
                  final article = horizontalArticles[index];
                  return buildArticleCard(context, article);
                },
              ));
        },
      ),
    );
  }

  Widget buildNewsVertical(BuildContext context) {
    return Expanded(
      child: Consumer<NewsViewModel>(
        builder: (context, model, child) {
          if (model.isLoadingVertical) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
          }
          if (model.articles.isEmpty) {
            return Center(
              child: Text("No Articles Available.",style: TextStyle(fontFamily: "Montserrat",fontWeight: FontWeight.bold),),
            );
          }
          final List<NewsArticle> verticalArticles = model.articles.skip(10).toList();
          return RefreshIndicator(
            color: AppColors.primaryColor,
              onRefresh: model.refreshNewsVertical,
              child: ListView.builder(
                controller: pageController2,
                itemCount: verticalArticles.length,
                itemBuilder: (context, index) {
                  final article = verticalArticles[index];
                  return buildSmallArticleCard(context, article);
                },
              ));
        },
      ),
    );
  }

  Widget buildCategories(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            Provider.of<NewsViewModel>(context, listen: false)
                .fetchTopHeadlinesVertical(category: category.code);
            Provider.of<NewsViewModel>(context, listen: false)
                .fetchTopHeadlinesHorizontal(category: category.code);
          },
          child: Column(
            children: [
              Container(
                width: 50, 
                height: 50,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 8.0), 
                decoration: BoxDecoration(
                  color: category.code ==
                          Provider.of<NewsViewModel>(context).selectedCategory
                      ? AppColors.primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15.0), 
                ),
                child: Icon(
                  category.icon, 
                  color: category.code == 
                          Provider.of<NewsViewModel>(context).selectedCategory
                          ? Colors.white
                          : Colors.grey,
                  size: 24, 
                ),
              ),
              SizedBox(height: 4), 
              Text(
                category.name,
                style: TextStyle(fontSize: 11,fontWeight:FontWeight.bold,fontFamily:  "Montserrat"),
                textAlign: TextAlign.center, 
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}




  Widget buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    bool isDarkTheme = theme.brightness == Brightness.dark;
    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              height: 120.0,
              alignment: Alignment.center,
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text("Switch Theme"),
              trailing: Switch(
                value: isDarkTheme,
                onChanged: (value) {
                  widget.onToggleTheme();
                },
              ),
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize appBAr(BuildContext context, Color backgroundColor) {
    return PreferredSize(
      preferredSize: Size.fromHeight(75.0),
      child: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(FontAwesomeIcons.chartBar,color: AppColors.primaryColor,),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0.0,
        title: AnimatedSwitcher(
          duration : Duration(milliseconds: 300),
          transitionBuilder : (Widget child , Animation<double> animation){
            return SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -5.0,
              child: child,
              );
          },
        child: !_isSearching
            ? Text("News App",key: ValueKey(1),)
            : TextField(
                key: ValueKey(2),
                onChanged: (query) {
                  Provider.of<NewsViewModel>(context, listen: false)
                      .filterArticles(query);
                },
                controller: searchcontroller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        searchcontroller.clear();
                        _isSearching = false;
                      });
                    },
                  ),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Icon(FontAwesomeIcons.searchengin),
                ),
              ),
        ),
        actions: _buildAppBarActions(),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (!_isSearching) {
      return [
        IconButton(
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
            icon: Icon(FontAwesomeIcons.magnifyingGlass,color: AppColors.primaryColor,)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            ImageConstants.instance.splashIcon,
            width: 40,
            height: 40,
          ),
        )
      ];
    } else {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            ImageConstants.instance.splashIcon,
            width: 40,
            height: 40,
          ),
        ),
        Container()
      ];
    }
  }

  void navigatetoDetail(BuildContext context, NewsArticle article) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                NewsDetailView(article: article),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            }));
  }
}
