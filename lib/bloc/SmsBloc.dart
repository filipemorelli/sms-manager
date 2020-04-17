import 'dart:async';
import 'dart:developer';

import 'package:sms/sms.dart';

class SmsBloc {
  StreamController<List<SmsThread>> _streamController;

  Stream<List<SmsThread>> get stream => _streamController.stream;

  static final SmsBloc instance = SmsBloc._();

  factory SmsBloc() => instance;

  SmsReceiver _smsReceiver;
  SmsQuery _smsQuery;

  SmsBloc._() {
    _streamController = StreamController.broadcast();
    _smsQuery = SmsQuery();
    _smsReceiver = SmsReceiver();
  }

  loadSmsthreads() async {
    try {
      _streamController.sink.add(await _smsQuery.getAllThreads);
      await _updateMessages();
    } catch (e, stackTrace) {
      log(e.toString(), name: "SmsBloc.loadSmsthreads", stackTrace: stackTrace);
    }
  }

  _updateMessages() async {
    _smsReceiver.onSmsReceived.listen((smsReceiver) async {
      try {
        _streamController.sink.add(await _smsQuery.getAllThreads);
      } catch (e, stackTrace) {
        log(e.toString(),
            name: "SmsBloc._updateMessages", stackTrace: stackTrace);
      }
    });
  }

  dispose() {
    _streamController.close();
  }
}
