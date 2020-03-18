import 'dart:async';
import 'dart:developer';

import 'package:sms/sms.dart';

class SmsBloc {
  StreamController<List<SmsThread>> _streamController;

  Stream<List<SmsThread>> get stream => _streamController.stream;

  static final SmsBloc instance = SmsBloc._();

  factory SmsBloc() => instance;

  SmsBloc._() {
    _streamController = StreamController.broadcast();
  }

  loadSmsthreads() async {
    try {
      var smsQuery = SmsQuery();
      _streamController.sink.add(await smsQuery.getAllThreads);
    } catch (e, stackTrace) {
      log(e.toString(), name: "SmsBloc.loadSmsthreads", stackTrace: stackTrace);
    }
  }

  dispose() {
    _streamController.close();
  }
}
