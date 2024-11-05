import 'package:flutter/material.dart';
import 'package:news_app/src/login/view/login_view.dart';

class RegisterViewModel extends ChangeNotifier{
  
  void navigateToLogin(BuildContext context){
    Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 750), // Aynı geçiş süresi
  ),
);

  }
}