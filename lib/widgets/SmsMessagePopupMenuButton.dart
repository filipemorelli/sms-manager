import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/globals/enums.dart';

class SmsMessagePopupMenuButton extends StatelessWidget {
  final SmsThread smsThread;
  const SmsMessagePopupMenuButton({
    Key key,
    @required this.smsThread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      tooltip: "Menu",
      onSelected: (SmsMessagePopupMenuItemType option) {
        switch (option) {
          case SmsMessagePopupMenuItemType.archived:
            Navigator.pushNamed(context, "settings");
            break;
          case SmsMessagePopupMenuItemType.info:
            Navigator.pushNamed(context, "notFound");
            break;
          default:
        }
      },
      itemBuilder: (ctx) {
        return listPopUpMenu();
      },
    );
  }

  List<PopupMenuItem<SmsMessagePopupMenuItemType>> listPopUpMenu() {
    List<PopupMenuItem<SmsMessagePopupMenuItemType>> list = [
      PopupMenuItem(
        value: SmsMessagePopupMenuItemType.info,
        child: Text("Informações"),
      ),
      PopupMenuItem(
        value: SmsMessagePopupMenuItemType.search,
        child: Text("Pesquisar"),
      ),
      PopupMenuItem(
        value: SmsMessagePopupMenuItemType.archived,
        child: Text("Arquivar"),
      ),
      PopupMenuItem(
        value: SmsMessagePopupMenuItemType.remove,
        child: Text("Excluir"),
      ),
      PopupMenuItem(
        value: SmsMessagePopupMenuItemType.help,
        child: Text("Ajuda e feedback"),
      ),
    ];
    if (this.smsThread.contact.fullName == null) {
      list.insert(
        0,
        PopupMenuItem(
          value: SmsMessagePopupMenuItemType.addContact,
          child: Text("Adicionar Contato"),
        ),
      );
    }
    return list;
  }
}
