import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlinesVertical(category: ' ');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsViewModel>(context, listen: false).fetchTopHeadlinesHorizontal(category: ' ');
    });
  }

  @override
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
          SizedBox(height: 30.h,),
          textLine(context,"News Today"),
          SizedBox(height: 15.h,),
          buildNewsHorizontal(context),
          SizedBox(height: 15.h,),
          textLine(context, "Latest News"),
          SizedBox(height: 15.h,),
          buildNewsVertical(context)
        ],
      ),
    );
  }

  Widget textLine(BuildContext context,String text){
    return Row(
      children: [
        SizedBox(width: 15.w,),
         Text(text,style: TextStyle(fontFamily:"Montserrat" ,fontSize: 22.sp,fontWeight: FontWeight.bold,),),
         SizedBox(width: 200.w,),
        Icon(Icons.menu,size: 25.sp,)
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
    margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
    child: InkWell(
      onTap: () {
        navigatetoDetail(context, article);
      },
      child: Padding(
        padding: EdgeInsets.all(5.w), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                article.imageUrl,
                width: 100.w, 
                height: 100.h, 
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 15.w), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis, 
                  ),
                  SizedBox(height: 20.h,),
                  Text(
                    timeAgo(article.publishedAt),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
  ));
}


  Widget buildArticleCard(BuildContext context, NewsArticle article) {
  final theme = Theme.of(context);
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    shadowColor: Colors.black,
    elevation: 4,
    color: theme.scaffoldBackgroundColor,
    margin: EdgeInsets.all(10.w),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
                child: Image.network(
                  article.imageUrl,
                  width: double.infinity,
                  height: 170.h, 
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8.w,
                bottom: 8.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    timeAgo(article.publishedAt), 
                    style: TextStyle(color: Colors.white, fontSize: 13.sp,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              article.title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}




  Widget buildNewsHorizontal(BuildContext context) {
    return SizedBox(
      height: 300.h,
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
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
          }
          if (model.articles.isEmpty) {
            return const Center(
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
                width: 50.w, 
                height: 50.h,
                padding: EdgeInsets.all(8.0.w),
                margin: EdgeInsets.symmetric(horizontal: 8.0.w), 
                decoration: BoxDecoration(
                  color: category.code ==
                          Provider.of<NewsViewModel>(context).selectedCategory
                      ? AppColors.primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15.0.r), 
                ),
                child: Icon(
                  category.icon, 
                  color: category.code == 
                          Provider.of<NewsViewModel>(context).selectedCategory
                          ? Colors.white
                          : Colors.grey,
                  size: 24.sp, 
                ),
              ),
              SizedBox(height: 4.h), 
              Text(
                category.name,
                style: TextStyle(fontSize: 11.sp,fontWeight:FontWeight.bold,fontFamily:  "Montserrat"),
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
              height: 120.0.h,
              alignment: Alignment.center,
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24.sp),
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
      preferredSize: Size.fromHeight(75.0.h),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
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
                    borderRadius: BorderRadius.circular(30.0.r),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Image.asset(
            ImageConstants.instance.splashIcon,
            width: 40.w,
            height: 40.h,
          ),
        )
      ];
    } else {
      return [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Image.asset(
            ImageConstants.instance.splashIcon,
            width: 40.w,
            height: 40.h,
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
