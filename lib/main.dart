
import 'package:flutter/material.dart';
import 'package:news_app/src/news/view/news_list_view.dart';
import 'package:news_app/src/news/view_model/news_view_model.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsViewModel()..fetchTopHeadlines(),
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NewsListView(),
      )
    );
  }
}
