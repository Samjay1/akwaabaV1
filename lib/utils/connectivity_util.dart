import 'dart:async';

import 'package:akwaaba/constants/app_strings.dart';
import 'package:akwaaba/main.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // 1.
  void initialise(BuildContext context) async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    // ignore: use_build_context_synchronously
    _checkStatus(result, context);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      debugPrint('$result');
      _checkStatus(result, context);
    });
  }

// 2.
  void _checkStatus(ConnectivityResult result, BuildContext context) async {
    bool isOnline = false;
    // whenevery connection status is changed.
    if (result == ConnectivityResult.none) {
      // there is no any connectiond

      SnackbarGlobal.show('No Internet Connection');
      isOnline = false;
    } else if (result == ConnectivityResult.mobile) {
      // connection is mobile data network

      isOnline = true;
      SnackbarGlobal.key.currentState!.removeCurrentSnackBar();
    } else if (result == ConnectivityResult.wifi) {
      // connection is from wifi

      isOnline = true;
      SnackbarGlobal.key.currentState!.removeCurrentSnackBar();
    }
    // try {
    //   final result = await InternetAddress.lookup('example.com');
    //   isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    // } on SocketException catch (_) {
    //   isOnline = false;
    // }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
