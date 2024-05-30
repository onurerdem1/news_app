import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel() {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration(seconds: 3));
  }
}
