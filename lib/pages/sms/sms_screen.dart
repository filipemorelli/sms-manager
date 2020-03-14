import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/widgets/BuildSmsMessagesList.dart';
import 'package:smsmanager/widgets/SmsPopupMenuButton.dart';

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
              return BuildSmsMessagesList(listSmsThread: snapshot.data);
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
