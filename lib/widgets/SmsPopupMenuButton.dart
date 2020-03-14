import 'package:flutter/material.dart';
import 'package:smsmanager/globals/enums.dart';

class SmsPopupMenuButton extends StatelessWidget {
  const SmsPopupMenuButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      tooltip: "Menu",
      onSelected: (SmsPopupMenuItemType option) {
        switch (option) {
          case SmsPopupMenuItemType.web:
            Navigator.pushNamed(context, "settings");
            break;
          case SmsPopupMenuItemType.settings:
            Navigator.pushNamed(context, "notFound");
            break;
          default:
        }
      },
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: SmsPopupMenuItemType.web,
            child: Text("Mensagens na web"),
          ),
          PopupMenuItem(
            value: SmsPopupMenuItemType.blocked,
            child: Text("Contatos bloqueados"),
          ),
          PopupMenuItem(
            value: SmsPopupMenuItemType.darkmode,
            child: Text("Ativar modo escuro"),
          ),
          PopupMenuItem(
            value: SmsPopupMenuItemType.archived,
            child: Text("Arquivadas"),
          ),
          PopupMenuItem(
            value: SmsPopupMenuItemType.settings,
            child: Text("Configurações"),
          ),
          PopupMenuItem(
            value: SmsPopupMenuItemType.help,
            child: Text("Ajuda e feedback"),
          ),
        ];
      },
    );
  }
}
