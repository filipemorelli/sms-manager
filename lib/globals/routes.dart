import 'package:flutter/material.dart';
import 'package:smsmanager/pages/404/not_found.dart';
import 'package:smsmanager/pages/sms/sms_screen.dart';
import 'package:smsmanager/pages/sms_messages/sms_messages_screen.dart';

Route<dynamic> onGeneratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case "sms":
      return MaterialPageRoute(builder: (_) => SmsScreen(), settings: settings);
      break;
    case "sms-messages":
      return MaterialPageRoute(
          builder: (_) => SmsMessagesScreen(smsThread: settings.arguments),
          settings: settings);
      break;
    default:
      return MaterialPageRoute(
          builder: (_) => NotFoundScreen(), settings: settings);
  }
}
