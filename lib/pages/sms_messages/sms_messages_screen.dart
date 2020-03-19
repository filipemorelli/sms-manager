import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/bloc/IconSendMessageBloc.dart';
import 'package:smsmanager/globals/constants.dart';
import 'package:smsmanager/widgets/BuildCircularAvatar.dart';
import 'package:smsmanager/widgets/SmsMessagePopupMenuButton.dart';

class SmsMessagesScreen extends StatefulWidget {
  final SmsThread smsThread;

  SmsMessagesScreen({@required this.smsThread});

  @override
  _SmsMessagesScreenState createState() => _SmsMessagesScreenState();
}

class _SmsMessagesScreenState extends State<SmsMessagesScreen> {
  IconSendMessageBloc _streamControllerSend;
  ScrollController _scrollController;
  ValueNotifier<bool> _showFloatActionBarNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _streamControllerSend = IconSendMessageBloc();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 150) {
        _showFloatActionBarNotifier.value = true;
      } else {
        _showFloatActionBarNotifier.value = false;
      }
    });
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
        title: Row(
          children: <Widget>[
            buildCircleAvatar(widget.smsThread, widget.smsThread.id - 1),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                widget.smsThread.contact.fullName != null
                    ? widget.smsThread.contact.fullName
                    : widget.smsThread.address,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
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
                child: buildListMessages(),
              ),
              buildInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListMessages() {
    return Scaffold(
      body: Scrollbar(
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(
            top: spaceSize,
            right: spaceSize,
            left: spaceSize,
          ),
          itemCount: widget.smsThread.messages.length,
          reverse: true,
          itemBuilder: (ctx, index) {
            SmsMessage message = widget.smsThread.messages[index];
            return message.address == widget.smsThread.address
                ? buildLeftContainer(message)
                : buildRightContainer(message);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showFloatActionBarNotifier,
        builder: (ctx, value, w) {
          return value
              ? Transform.scale(
                  scale: 0.8,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.blueGrey.shade800,
                    icon: Icon(Icons.arrow_downward),
                    label: Text("See last message"),
                    onPressed: () {
                      _scrollController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    },
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }

  Widget buildLeftContainer(SmsMessage message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200,
          ),
          width: MediaQuery.of(context).size.width * 0.75,
          margin: EdgeInsets.only(bottom: 3),
          padding: EdgeInsets.symmetric(horizontal: spaceSize, vertical: 10),
          child: Text(
            message.body,
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: spaceSize),
          child: Text(
            DateFormat('hh:mm a MM/dd/yyyy').format(message.date),
            style: TextStyle(fontSize: 11),
          ),
        )
      ],
    );
  }

  Widget buildRightContainer(SmsMessage message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue.shade100,
          ),
          width: MediaQuery.of(context).size.width * 0.75,
          margin: EdgeInsets.only(bottom: 3),
          padding: EdgeInsets.symmetric(horizontal: spaceSize, vertical: 10),
          child: Text(
            message.body,
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: spaceSize),
          child: Text(
            DateFormat('hh:mm a MM/dd/yyyy').format(message.dateSent),
            style: TextStyle(fontSize: 11),
          ),
        )
      ],
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
