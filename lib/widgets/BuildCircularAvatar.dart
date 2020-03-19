import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/globals/styles.dart';

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
