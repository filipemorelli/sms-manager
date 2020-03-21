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

final smsTextUnreadStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

final smsTextReadStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.normal,
);

final circularTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
);

final smsDateTextStyle = TextStyle(
  fontSize: 12,
);
