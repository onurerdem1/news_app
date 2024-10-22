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
    Future.delayed(Duration(seconds: 3), () {
      final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
      navigatetoHome(context,themeProvider);
    }
    );
  }

  void navigatetoHome(BuildContext context,ThemeProvider themeProvider){
    Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation)=> NewsListView(onToggleTheme: (){themeProvider.toggleTheme();}),
          transitionsBuilder: (context,animation,secondaryAnimation,child){
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin,end: end,).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 750)
        )
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
