import 'package:flutter/material.dart';
import 'package:smsmanager/globals/constants.dart';
import 'package:smsmanager/globals/routes.dart';
import 'package:smsmanager/globals/styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sms Manager',
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      showSemanticsDebugger: showSemanticsDebugger,
      navigatorKey: navigatorKey,
      theme: mainThemData,
      initialRoute: "sms",
      onGenerateRoute: onGeneratedRoutes,
    );
  }
}
