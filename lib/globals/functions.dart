import 'package:flutter/material.dart';

showToast({
  @required GlobalKey<ScaffoldState> scaffoldKey,
  @required String text,
}) {
  if (scaffoldKey != null) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 5),
    ));
  }
}
