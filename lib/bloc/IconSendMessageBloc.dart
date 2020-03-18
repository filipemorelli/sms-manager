import 'dart:async';

class IconSendMessageBloc {
  StreamController<bool> _streamController;

  Stream<bool> get stream => _streamController.stream;

  IconSendMessageBloc() {
    _streamController = StreamController<bool>.broadcast();
  }

  changeValue(bool value) {
    _streamController.sink.add(value);
  }

  dispose() {
    _streamController.close();
  }
}
