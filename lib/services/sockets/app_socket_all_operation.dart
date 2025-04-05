import 'package:flutter_getx_project_template/constant/app_api_end_point.dart';
import 'package:flutter_getx_project_template/utils/app_log.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AppSocketAllOperation {
  AppSocketAllOperation._privateConstructor();
  static final AppSocketAllOperation _instance = AppSocketAllOperation._privateConstructor();
  static AppSocketAllOperation get instance => _instance;

  io.Socket? appRootSocket;
  bool _isConnecting = false;
  final Map<String, List<void Function(dynamic)>> _eventHandlers = {};

  bool get isConnected => appRootSocket?.connected == true;

  void initializeSocket() {
    if (appRootSocket != null) return;

    _connectSocketToServer();
  }

  void readEvent({required String event, required void Function(dynamic) handler}) {
    try {
      // Store the handler for reconnection scenarios
      if (!_eventHandlers.containsKey(event)) {
        _eventHandlers[event] = [];
      }
      _eventHandlers[event]!.add(handler);

      // If already connected, setup the listener immediately
      if (isConnected) {
        _setupEventListener(event, handler);
      } else {
        // If not connected, initialize the connection
        initializeSocket();
      }
    } catch (e, stackTrace) {
      errorLog("readEvent ($event)$e", stackTrace);
    }
  }

  void _setupEventListener(String event, void Function(dynamic) handler) {
    appRootSocket?.off(event); // Remove existing listeners to avoid duplicates
    appRootSocket?.on(event, (data) {
      appLog("Received event: $event ");
      appLog("with data: $data");
      handler(data);
    });
  }

  void emitEvent(String event, dynamic data) {
    try {
      if (isConnected) {
        appRootSocket?.emit(event, data);
      } else {
        // Queue the emit for when connection is established
        initializeSocket();
        _onceConnected(() {
          appRootSocket?.emit(event, data);
        });
      }
    } catch (e, stackTrace) {
      errorLog("emitEvent ($event) $e", stackTrace);
    }
  }

  void _onceConnected(void Function() callback) {
    if (isConnected) {
      callback();
      return;
    }

    void listener(dynamic listener) {
      try {
        callback();
        appRootSocket?.off('connect', listener);
      } catch (e) {
        errorLog("listener", e);
      }
    }

    appRootSocket?.on('connect', listener);
  }

  void vendorLiveLocationUpdate({required String orderId, required dynamic latitude, required dynamic longitude}) {
    try {
      final data = {"orderId": orderId, "latitude": _convertToDouble(latitude), "longitude": _convertToDouble(longitude)};
      emitEvent("liveTracking", data);
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
      if (appRootSocket != null || _isConnecting) return;

      _isConnecting = true;
      appLog("Attempting to connect socket...");

      appRootSocket = io.io(
        AppApiEndPoint.instance.domain,
        io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().setExtraHeaders({'foo': 'bar'}).enableReconnection().build(),
      );

      // Setup connection listeners
      appRootSocket?.onConnect((_) {
        _isConnecting = false;
        appLog("Socket connected");

        // Re-establish all event listeners using for loops
        for (final entry in _eventHandlers.entries) {
          final event = entry.key;
          final handlers = entry.value;
          for (final handler in handlers) {
            _setupEventListener(event, handler);
          }
        }
      });

      appRootSocket?.onDisconnect((_) {
        errorLog("Socket disconnected", "");
        _isConnecting = false;
      });

      appRootSocket?.onConnectError((data) {
        errorLog("Connect error", data);
        _isConnecting = false;
      });

      appRootSocket?.onError((data) {
        errorLog("Error", data);
        _isConnecting = false;
      });

      appRootSocket?.onReconnect((_) {
        appLog("Socket reconnected");
      });

      // Start the connection
      appRootSocket?.connect();
    } catch (e, stackTrace) {
      _isConnecting = false;
      errorLog("_connectSocketToServer $e", stackTrace);
    }
  }

  void reconnect() {
    if (!isConnected && !_isConnecting) {
      _connectSocketToServer();
    }
  }

  void dispose() {
    if (appRootSocket != null) {
      appRootSocket?.disconnect();
      appRootSocket?.dispose();
      appRootSocket = null;
    }
    _eventHandlers.clear();
    _isConnecting = false;
  }
}
