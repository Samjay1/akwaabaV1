import 'dart:io';

import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadUtil {
  static downloadFile({required String url}) async {
    await FlutterDownloader.enqueue(
      url: url,
      //headers: {}, // optional: header send with url (auth token etc)
      savedDir: await getTempDirectory(),
      saveInPublicStorage: true,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    showNormalToast('File downloaded');
  }

  static Future<String> getTempDirectory() async {
    String dir = '';
    if (Platform.isAndroid) {
      dir = (await getTemporaryDirectory()).path;
    } else if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    debugPrint(dir);
    return dir;
  }
}
