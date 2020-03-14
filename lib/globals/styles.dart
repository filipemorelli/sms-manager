import 'package:flutter/material.dart';

final ThemeData mainThemData = ThemeData(
  primarySwatch: Colors.blue,
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    elevation: 5,
  ),
  appBarTheme: AppBarTheme(
    elevation: 5,
    color: Colors.white,
  ),
);
