import 'package:flutter/material.dart';


extension ThemeContext on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorScheme => themeData.colorScheme;
  IconThemeData get iconTheme => themeData.iconTheme;
  TextTheme get textTheme => themeData.textTheme;
}
