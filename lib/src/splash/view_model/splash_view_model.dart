import 'package:flutter/material.dart';
import 'package:news_app/src/login/view/login_view.dart';
import 'package:news_app/src/theme_provider.dart';


class SplashViewModel extends ChangeNotifier {
  SplashViewModel() {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration(seconds: 3));
  }

  void navigatetoHome(BuildContext context,ThemeProvider themeProvider){
    Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation)=> LoginScreen(),
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
}
