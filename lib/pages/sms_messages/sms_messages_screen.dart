import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/bloc/IconSendMessageBloc.dart';
import 'package:smsmanager/globals/constants.dart';
import 'package:smsmanager/globals/functions.dart';
import 'package:smsmanager/widgets/BuildCircularAvatar.dart';
import 'package:smsmanager/widgets/SmsMessagePopupMenuButton.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ValueNotifier<List<SmsMessage>> _listSmsMessages =
      ValueNotifier<List<SmsMessage>>(<SmsMessage>[]);
  TextEditingController _smsTextEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SmsSender sender = new SmsSender();
  SmsReceiver receiver = new SmsReceiver();

  @override
  void initState() {
    super.initState();
    _streamControllerSend = IconSendMessageBloc();
    _streamControllerSend.changeValue(true);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 150) {
        _showFloatActionBarNotifier.value = true;
      } else {
        _showFloatActionBarNotifier.value = false;
      }
    });
    _listSmsMessages.value = widget.smsThread.messages.toList();
    updateChatMessages();
  }

  updateChatMessages() {
    receiver.onSmsReceived.asBroadcastStream().listen((smsMessage) async {
      if (widget.smsThread.threadId == smsMessage.threadId) {
        var newSmsThread = await SmsQuery().queryThreads(
          [widget.smsThread.threadId],
          kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent],
        );
        _listSmsMessages.value = newSmsThread[0].messages;
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
      key: _scaffoldKey,
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
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: callToContact,
          ),
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

  void callToContact() async {
    await launch("tel:${widget.smsThread.address}");
  }

  Widget buildListMessages() {
    return Scaffold(
      body: Scrollbar(
        child: ValueListenableBuilder<List<SmsMessage>>(
          valueListenable: _listSmsMessages,
          builder: (ctx, listSmsMessage, w) {
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: spaceSize,
                right: spaceSize,
                left: spaceSize,
              ),
              itemCount: listSmsMessage.length,
              reverse: true,
              itemBuilder: (ctx, index) {
                SmsMessage message = listSmsMessage[index];
                return message.kind == SmsMessageKind.Received
                    ? buildLeftContainer(message)
                    : buildRightContainer(message);
              },
            );
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
              child: TextFormField(
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                controller: _smsTextEditingController,
                onChanged: (value) =>
                    _streamControllerSend.changeValue(value.isEmpty),
              ),
            ),
          ),

          // Button send message
          StreamBuilder<bool>(
            stream: _streamControllerSend.stream,
            initialData: true,
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send,
                      color: snapshot.data ? Colors.grey : Colors.blue),
                  onPressed: !snapshot.data
                      ? () async {
                          var smsMessage = SmsMessage(
                            widget.smsThread.address,
                            _smsTextEditingController.value.text,
                            kind: SmsMessageKind.Sent,
                            threadId: widget.smsThread.threadId,
                            dateSent: DateTime.now(),
                            date: DateTime.now(),
                            read: true,
                          );
                          try {
                            await sender.sendSms(smsMessage);
                            widget.smsThread.addNewMessage(smsMessage);
                            _listSmsMessages.value = widget.smsThread.messages;
                            _smsTextEditingController.clear();
                          } catch (e) {
                            showToast(
                              scaffoldKey: _scaffoldKey,
                              text: "We can`t send your message.",
                            );
                          }
                        }
                      : null,
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
