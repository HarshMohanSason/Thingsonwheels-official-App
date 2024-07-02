
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectionStatus { connected, disconnected, connecting }

class InternetProvider extends ChangeNotifier {
  ConnectionStatus _connectionStatus = ConnectionStatus.connecting;
  bool _hasInternet = false;

  final StreamController<ConnectionStatus> _connectionStatusController =
  StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  bool get hasInternet => _hasInternet;

  InternetProvider() {
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  Future<void> retryInternetConnection() async {
    _connectionStatus = ConnectionStatus.connecting;
    notifyListeners();
    await checkInternetConnection();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _connectionStatus = ConnectionStatus.disconnected;
      _hasInternet = false;
    } else {
      _connectionStatus = ConnectionStatus.connected;
      _hasInternet = true;
    }
    _connectionStatusController.add(_connectionStatus); // Emit status change
    notifyListeners();
  }

  @override
  void dispose() {
    _connectionStatusController.close();
    super.dispose();
  }
}
