import 'package:flutter_getx_project_template/constant/app_api_end_point.dart';
import 'package:flutter_getx_project_template/utils/app_log.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AppSocketAllOperation {
  static final AppSocketAllOperation _instance = AppSocketAllOperation._internal();
  factory AppSocketAllOperation() => _instance;

  io.Socket? appRootSocket;

  AppSocketAllOperation._internal() {
    _connectSocketToServer();
  }

  bool _isSocketConnected() {
    return appRootSocket != null && appRootSocket?.connected == true;
  }

  void readEvent({required String event, required void Function(dynamic) handler}) {
    try {
      if (_isSocketConnected()) {
        appRootSocket?.on(event, (data) {
          appLog("Received event: $event with data: $data");
          handler(data);
        });
      }
    } catch (e, stackTrace) {
      errorLog("readEvent ($event)$e", stackTrace);
    }
  }

  void emitEvent(String event, dynamic data) {
    try {
      if (_isSocketConnected()) {
        appRootSocket?.emit(event, data);
      }
    } catch (e, stackTrace) {
      errorLog("emitEvent ($event) $e", stackTrace);
    }
  }

  void vendorLiveLocationUpdate({required String orderId, required dynamic latitude, required dynamic longitude}) {
    try {
      if (_isSocketConnected()) {
        final data = {"orderId": orderId, "latitude": _convertToDouble(latitude), "longitude": _convertToDouble(longitude)};
        emitEvent("liveTracking", data);
      }
    } catch (e, stackTrace) {
      errorLog("vendorLiveLocationUpdate$e", stackTrace);
    }
  }

  double _convertToDouble(dynamic value) {
    try {
      return double.parse(value.toString());
    } catch (e, stackTrace) {
      errorLog("_convertToDouble $e", stackTrace);
      return 0.0;
    }
  }

  void _connectSocketToServer() {
    try {
      if (_isSocketConnected()) {
        return;
      }

      appRootSocket = io.io(
        AppApiEndPoint.instance.domain,
        io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build(),
      );

      appRootSocket?.connect();

      // Event listeners
      appRootSocket?.onConnect((_) => appLog("Socket connected"));
      appRootSocket?.onDisconnect((data) => errorLog("Socket disconnected", data));
      appRootSocket?.onConnectError((data) => errorLog("Connect error", data));
      appRootSocket?.onError((data) => errorLog("Error", data));
      appRootSocket?.onReconnect((_) => appLog("Socket reconnected"));
    } catch (e, stackTrace) {
      errorLog("_connectSocketToServer $e", stackTrace);
    }
  }

  void reconnect() {
    if (!_isSocketConnected()) {
      _connectSocketToServer();
    }
  }

  void dispose() {
    if (appRootSocket != null) {
      appRootSocket?.disconnect();
      appRootSocket?.dispose();
      appRootSocket = null;
    }
  }
}
