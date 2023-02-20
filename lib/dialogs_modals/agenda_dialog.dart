import 'dart:isolate';
import 'dart:ui';

import 'package:akwaaba/components/custom_rect_cached_image_widget.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/models/general/meetingEventModel.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/download_util.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class AgendaDialog extends StatefulWidget {
  final MeetingEventModel? meetingEventModel;
  const AgendaDialog({
    super.key,
    this.meetingEventModel,
  });

  @override
  State<AgendaDialog> createState() => _AgendaDialogState();
}

class _AgendaDialogState extends State<AgendaDialog> {
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    _registerDownloadTask();
    super.initState();
  }

  _registerDownloadTask() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all((AppPadding.p20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.025,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.meetingEventModel!.name!,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.01,
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text(
          //     DateUtil.formatStringDate(
          //       DateFormat.yMMMEd(),
          //       date: DateTime.parse(
          //         meetingEventModel!.updateDate!,
          //       ),
          //     ),
          //     style: TextStyle(
          //       color: blackColor.withOpacity(0.4),
          //       fontWeight: FontWeight.w500,
          //       fontSize: 18,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                widget.meetingEventModel!.agendaFile != ""
                    ? SizedBox(
                        width: displayWidth(context),
                        height: 220,
                        child: CustomRectCachedImageWidget(
                          url: widget.meetingEventModel!.agendaFile!,
                          height: 130,
                        ),
                      )
                    : Container(
                        width: displayWidth(context),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                              image: AssetImage('images/placeholder.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.meetingEventModel!.agenda!,
                    style: const TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: displayHeight(context) * 0.02,
                ),
                widget.meetingEventModel!.agendaFile != ""
                    ? InkWell(
                        onTap: () => DownloadUtil.downloadFile(
                          url: widget.meetingEventModel!.agendaFile!,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: primaryColor,
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Download File',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              10.pw,
                              const Icon(
                                CupertinoIcons.cloud_download,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    // : const SizedBox(),
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: greyColorShade300,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            8.pw,
                            const Text(
                              'No attachment found',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
