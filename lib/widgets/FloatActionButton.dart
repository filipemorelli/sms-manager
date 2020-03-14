import 'package:flutter/material.dart';

class SmsFloatActionButton extends StatelessWidget {
  final ValueNotifier<bool> isExtendedFloatActionBar;

  const SmsFloatActionButton({
    Key key,
    @required this.isExtendedFloatActionBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExtendedFloatActionBar,
      child: FloatingActionButton(onPressed: null),
      builder: (ctx, result, widget) {
        return result
            ? FloatingActionButton.extended(
                onPressed: () {},
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                label: Text("Nova mensagem"),
                tooltip: "Nova mensagem",
                backgroundColor: Colors.blueAccent)
            : FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                tooltip: "Nova mensagem",
                backgroundColor: Colors.blueAccent,
              );
      },
    );
  }
}
