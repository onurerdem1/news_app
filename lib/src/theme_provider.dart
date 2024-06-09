import 'package:flutter/material.dart';

import '../core/theme/dark.dart';
import '../core/theme/light.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    if(_themeData.brightness==Brightness.dark){
      _themeData= lightTheme;
    }
    else _themeData=darkTheme;
    notifyListeners();
  }
}
