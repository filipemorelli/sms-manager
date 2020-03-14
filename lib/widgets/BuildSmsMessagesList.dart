import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class BuildSmsMessagesList extends StatelessWidget {
  final List<SmsThread> listSmsThread;
  const BuildSmsMessagesList({Key key, @required this.listSmsThread})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listSmsThread.length,
      itemBuilder: (ctx, i) {
        SmsThread smsThread = listSmsThread[i];
        return ListTile(
          key: Key(smsThread.threadId.toString()),
          leading: CircleAvatar(
            child: smsThread.contact.fullName != null
                ? Text(
                    smsThread.contact.fullName[0].toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                : Icon(Icons.person, color: Colors.white),
            backgroundColor: Colors.primaries[i % Colors.primaries.length],
          ),
          title: Text(
            smsThread.contact.fullName != null
                ? smsThread.contact.fullName
                : smsThread.address,
            style: TextStyle(
                fontWeight:
                    !smsThread.messages.last.isRead ? FontWeight.bold : null),
          ),
          subtitle: Text(
            smsThread.messages[0].body,
            maxLines: !smsThread.messages.last.isRead ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight:
                    !smsThread.messages.last.isRead ? FontWeight.bold : null),
          ),
        );
      },
    );
  }
}
