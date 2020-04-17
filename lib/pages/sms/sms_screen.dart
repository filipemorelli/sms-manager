import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:smsmanager/bloc/SmsBloc.dart';
import 'package:smsmanager/widgets/BuildSmsMessagesList.dart';
import 'package:smsmanager/widgets/FloatActionButton.dart';
import 'package:smsmanager/widgets/SmsPopupMenuButton.dart';

import '../../bloc/SmsBloc.dart';
import '../../globals/functions.dart';

class SmsScreen extends StatefulWidget {
  @override
  _SmsScreenState createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  SmsQuery query;
  ScrollController scrollController;
  ValueNotifier<bool> isExtendedFloatActionBar = ValueNotifier<bool>(true);
  DateTime currentBackPressTime;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isExtendedFloatActionBar = ValueNotifier<bool>(true);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      SmsBloc.instance.loadSmsthreads();
    });
  }

  Future getAllSms() {
    return query.getAllSms;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          isExtendedFloatActionBar.value = scroll.metrics.pixels <= 30;
          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Messages",
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
            child: RefreshIndicator(
              onRefresh: () {
                return SmsBloc.instance.loadSmsthreads();
              },
              child: Scrollbar(
                child: StreamBuilder<List<SmsThread>>(
                  stream: SmsBloc.instance.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return BuildSmsMessagesList(
                      listSmsThread: snapshot.data,
                      scrollController: scrollController,
                    );
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: SmsFloatActionButton(
            isExtendedFloatActionBar: isExtendedFloatActionBar,
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 3)) {
      currentBackPressTime = now;
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Press back again to exit."),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: "Cancel",
            onPressed: () => currentBackPressTime = null,
          ),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
