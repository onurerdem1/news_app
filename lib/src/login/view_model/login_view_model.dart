import 'package:flutter/cupertino.dart';
import 'package:news_app/src/news/view/news_home_view.dart';
import 'package:news_app/src/register/view/register_view.dart';
import 'package:news_app/src/theme_provider.dart';

class LoginViewModel extends ChangeNotifier{
  LoginViewModel() {
     _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration(seconds: 3));
  }

  void navigatetoHome(BuildContext context,ThemeProvider themeProvider){
    Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation)=> NewsListView(onToggleTheme: (){themeProvider.toggleTheme();}),
          transitionsBuilder: (context,animation,secondaryAnimation,child){
            const begin = Offset(1.0, 0.0);
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

  void navigateToRegister(BuildContext context,ThemeProvider themeProvider){
    Navigator.push(context,
        PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation)=> const RegisterScreen(),
          transitionsBuilder: (context,animation,secondaryAnimation,child){
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin,end: end,).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 750)
        )
    );
  }
}