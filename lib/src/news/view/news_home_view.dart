import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class _NewListViewState extends State<NewsListView> {
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
      Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlines(category: ' ');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: appBAr(context, theme.scaffoldBackgroundColor),
      drawer: buildDrawer(context),
      body: Column(
        children: [
          buildCategories(context),
          buildNews(context),
        ],
      ),
    );
  }

  Widget buildArticleCard(BuildContext context, NewsArticle article) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black,
      elevation: 8,
      margin: EdgeInsets.all(10),
      child: InkWell(
          onTap: () {
            navigatetoDetail(context, article);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  article.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }

  Widget buildNews(BuildContext context) {
    return Expanded(
      child: Consumer<NewsViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (model.articles.isEmpty) {
            return Center(
              child: Text("No Articles Available."),
            );
          }
          return RefreshIndicator(
              onRefresh: model.refreshNews,
              child: ListView.builder(
                itemCount: model.articles.length,
                itemBuilder: (context, index) {
                  final article = model.articles[index];
                  return buildArticleCard(context, article);
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Kategoriler arası eşit mesafe
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            Provider.of<NewsViewModel>(context, listen: false)
                .fetchTopHeadlines(category: category.code);
          },
          child: Column(
            children: [
              Container(
                width: 50, // Kare görünüm için genişlik ve yükseklik eşit
                height: 50,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 8.0), // Kategoriler arasında eşit boşluk
                decoration: BoxDecoration(
                  color: category.code ==
                          Provider.of<NewsViewModel>(context).selectedCategory
                      ? Colors.blue
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15.0), // Köşeleri yuvarla
                ),
                child: Icon(
                  category.icon, // Kategori ile ilgili ikon
                  color: Colors.white,
                  size: 24, // İkon boyutu
                ),
              ),
              SizedBox(height: 4), // Container ve metin arasında boşluk
              Text(
                category.name,
                style: TextStyle(color: Colors.black, fontSize: 12),
                textAlign: TextAlign.center, // Metni ortala
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
                // Handle navigation to home
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
                // Handle navigation to settings
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
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: backgroundColor,
        title: !_isSearching
            ? Text("News App")
            : TextField(
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
                  prefixIcon: Icon(Icons.search),
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
            icon: Icon(Icons.search)),
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
