import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/theme/light.dart';
import 'package:news_app/src/news/view_model/news_view_model.dart';
import 'package:news_app/src/splash/view/splash_view.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider(lightTheme)),
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            builder: (context,child) => MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: SplashView()
            ),
            designSize: Size(412, 915),
            );
        },
      ),
    );
  }
}
