import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/globals/enums.dart';

class SmsScreen extends StatefulWidget {
  @override
  _SmsScreenState createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  SmsQuery query;

  @override
  void initState() {
    super.initState();
    query = new SmsQuery();
  }

  Future getAllSms() {
    return query.getAllSms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Mensages",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
            tooltip: "Search",
          ),
          SmsPopupMenuButton()
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Scrollbar(
          child: FutureBuilder<List<SmsThread>>(
            future: query.getAllThreads,
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, i) {
                  SmsThread smsThread = snapshot.data[i];
                  return ListTile(
                    key: Key(smsThread.threadId.toString()),
                    leading: CircleAvatar(
                      child: smsThread.contact.fullName != null
                          ? Text(
                              smsThread.contact.fullName[0].toUpperCase(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          : Icon(Icons.person, color: Colors.white),
                      backgroundColor:
                          Colors.primaries[i % Colors.primaries.length],
                    ),
                    title: Text(
                      smsThread.contact.fullName != null
                          ? smsThread.contact.fullName
                          : smsThread.address,
                      style: TextStyle(
                          fontWeight: !smsThread.messages.last.isRead
                              ? FontWeight.bold
                              : null),
                    ),
                    subtitle: Text(
                      smsThread.messages[0].body,
                      maxLines: !smsThread.messages.last.isRead ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: !smsThread.messages.last.isRead
                              ? FontWeight.bold
                              : null),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
        tooltip: "Nova mensagem",
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
