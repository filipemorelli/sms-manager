import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/bloc/IconSendMessageBloc.dart';
import 'package:smsmanager/globals/constants.dart';
import 'package:smsmanager/widgets/SmsMessagePopupMenuButton.dart';

class SmsMessagesScreen extends StatefulWidget {
  final SmsThread smsThread;

  SmsMessagesScreen({@required this.smsThread});

  @override
  _SmsMessagesScreenState createState() => _SmsMessagesScreenState();
}

class _SmsMessagesScreenState extends State<SmsMessagesScreen> {
  IconSendMessageBloc _streamControllerSend;

  @override
  void initState() {
    super.initState();
    _streamControllerSend = IconSendMessageBloc();
  }

  @override
  void dispose() {
    _streamControllerSend.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.smsThread.contact.fullName != null
              ? widget.smsThread.contact.fullName
              : widget.smsThread.address,
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.phone), onPressed: () {}),
          SmsMessagePopupMenuButton(smsThread: widget.smsThread)
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: Center(
                  child: Text("Oii"),
                ),
              ),
              buildInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: spaceSize),
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) =>
                    _streamControllerSend.changeValue(value.isEmpty),
              ),
            ),
          ),

          // Button send message
          StreamBuilder<bool>(
            stream: _streamControllerSend.stream,
            initialData: false,
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send,
                      color: snapshot.data ? Colors.grey : Colors.blue),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
}
