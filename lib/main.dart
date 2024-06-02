import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/news/view/news_list_view.dart';
import 'package:news_app/src/news/view_model/news_view_model.dart';
import 'package:news_app/src/theme_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: AnimatedSplashScreen(
          splash: 'assets/splash/splash_icon.png',
          nextScreen: NewsListView(onToggleTheme: (){
            themeProvider.toggleTheme();
            },
          ),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.white,
          duration: 3000,
          )
            );
        },
      ),
    );
  }
}
