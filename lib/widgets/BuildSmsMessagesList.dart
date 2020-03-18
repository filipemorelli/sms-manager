import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/globals/constants.dart';
import 'package:smsmanager/globals/styles.dart';

class BuildSmsMessagesList extends StatelessWidget {
  final List<SmsThread> listSmsThread;
  final ScrollController scrollController;
  const BuildSmsMessagesList(
      {Key key, @required this.listSmsThread, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: listSmsThread.length,
      itemBuilder: (ctx, i) {
        SmsThread smsThread = listSmsThread[i];
        // Image.memory(smsThread.contact.thumbnail.bytes);
        return ListTile(
          key: Key(smsThread.threadId.toString()),
          leading: buildCircleAvatar(smsThread, i),
          title: Text(
            smsThread.contact.fullName != null
                ? smsThread.contact.fullName
                : smsThread.address,
            style: smsThread.messages.first.isRead
                ? smsTextReadStyle
                : smsTextUnreadStyle,
          ),
          subtitle: Text(
            smsThread.messages[0].body,
            maxLines: !smsThread.messages.first.isRead ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: smsThread.messages.first.isRead
                ? smsTextReadStyle
                : smsTextUnreadStyle,
          ),
          trailing: buildlastDateMessage(smsThread.messages.first.date),
          onTap: () {
            navigatorKey.currentState
                .pushNamed("sms-messages", arguments: smsThread);
          },
        );
      },
    );
  }

  Widget buildlastDateMessage(DateTime dateTime) {
    DateFormat format;
    String formatDate;
    if (dateTime.isBefore(DateTime.now().add(Duration(days: -7)))) {
      format = DateFormat('d MMM');
      formatDate = format.format(dateTime);
    } else if (dateTime.isAfter(DateTime.now().add(Duration(
        hours: -DateTime.now().hour,
        minutes: -DateTime.now().minute,
        seconds: -DateTime.now().second,
        milliseconds: -DateTime.now().millisecond)))) {
      format = DateFormat('H:m');
      formatDate = format.format(dateTime);
    } else {
      format = DateFormat('E');
      formatDate = format.format(dateTime);
    }
    return Text(
      formatDate,
      style: smsDateTextStyle,
      textAlign: TextAlign.right,
    );
  }

  Widget buildCircleAvatar(SmsThread smsThread, int i) {
    if (smsThread.contact.thumbnail != null) {
      return buildCircleAvatarThumbnail(smsThread);
    }
    return buildCircleAvatarText(smsThread, i);
  }

  Widget buildCircleAvatarText(SmsThread smsThread, int i) {
    return CircleAvatar(
      child: smsThread.contact.fullName != null
          ? Text(
              smsThread.contact.fullName[0].toUpperCase(),
              style: circularTextStyle,
            )
          : Icon(Icons.person, color: Colors.white),
      backgroundColor: Colors.primaries[i % Colors.primaries.length],
    );
  }

  Widget buildCircleAvatarThumbnail(SmsThread smsThread) {
    return CircleAvatar(
      backgroundImage: MemoryImage(smsThread.contact.thumbnail.bytes),
    );
  }
}
