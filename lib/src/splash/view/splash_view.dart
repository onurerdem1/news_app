import 'package:flutter/material.dart';
import 'package:news_app/src/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../news/view/news_home_view.dart';
import '../view_model/splash_view_model.dart';


class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    SplashViewModel splashViewModel = SplashViewModel();
    Future.delayed(Duration(seconds: 3), () {
      final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
      splashViewModel.navigatetoHome(context,themeProvider);
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/splash/splash_icon.png'),
        ),
      ),
    );
  }
}
