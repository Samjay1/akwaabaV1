import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/members/member_profile.dart';

class DeviceActivationRequestPage extends StatefulWidget {
  const DeviceActivationRequestPage({Key? key}) : super(key: key);

  @override
  State<DeviceActivationRequestPage> createState() =>
      _DeviceActivationRequestPageState();
}

class _DeviceActivationRequestPageState
    extends State<DeviceActivationRequestPage> {
  final TextEditingController _controllerEmailAddress = TextEditingController();
  SharedPreferences? prefs;
  var memberToken;
  var memberId;
  var deviceInfo;

  void loadToken() async {
    prefs = await SharedPreferences.getInstance();
    memberToken = prefs?.getString('token');
    Future.delayed(Duration.zero, () {
      //GETS MEMBER PROFILE INFO
      MemberProfile memberProfile =
          Provider.of<MemberProvider>(context, listen: false).memberProfile;
      memberId = memberProfile.user!.id; // GETS THE MEMBER ID
      Provider.of<MemberProvider>(context, listen: false).callDeviceRequestList(
          memberToken: memberToken, memberID: memberId, context: context);
      debugPrint('DEVICE ACTIVATION TOKEN $memberToken');
      //GETS DEVICE INFO
      deviceInfo =
          Provider.of<MemberProvider>(context, listen: false).deviceInfoModel;
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    //GETS TOKEN AND LOADS DEVICE REQUEST LIST
    loadToken();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Activation"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        // decoration: BoxDecoration(color: Colors.orange),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: height * 0.25,
            child: Column(
              children: [
                LabelWidgetContainer(
                    label: "Device Type",
                    child: Text("${deviceInfo?.deviceType}")),
                const SizedBox(
                  height: 20,
                ),
                LabelWidgetContainer(
                    label: "Device ID", child: Text("${deviceInfo?.deviceId}")),
                const SizedBox(
                  height: 36,
                ),
                CustomElevatedButton(
                  label: "Request Activation",
                  textColor: whiteColor,
                  function: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        insetPadding: const EdgeInsets.all(10),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: ConfirmDialog(
                          title: 'Request Device Activation',
                          content:
                              "Are you sure you want to request activation for this device? \nPlease note that your device information will be sent for verification. This information will not be shared with any other third parties or applications.",
                          onConfirmTap: () {
                            Navigator.pop(context);
                            MemberAPI api = MemberAPI();
                            api.requestDeviceActivation(
                              memberId: memberId,
                              systemDevice: deviceInfo?.systemDevice,
                              deviceType: deviceInfo?.deviceType,
                              deviceId: deviceInfo?.deviceId,
                            );
                          },
                          onCancelTap: () => Navigator.pop(context),
                          confirmText: 'Yes',
                          cancelText: 'Cancel',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Center(
            child: Text('Device Requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Expanded(
            child: Container(
                //height: height * 0.65,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange)),
                // color: Colors.blue,
                child: Consumer<MemberProvider>(
                  builder: (context, data, child) {
                    return data.loading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => Provider.of<MemberProvider>(
                                    context,
                                    listen: false)
                                .callDeviceRequestList(
                              memberToken: memberToken,
                              memberID: memberId,
                              context: context,
                            ),
                            child: data.deviceRequestList.isEmpty
                                ? const EmptyStateWidget(
                                    text:
                                        'You currently have no device activation requests at the moment!',
                                  )
                                : ListView.builder(
                                    itemCount: data.deviceRequestList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var item = data.deviceRequestList[index];
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Device ID'),
                                              SizedBox(
                                                width: displayWidth(context) *
                                                    0.02,
                                              ),
                                              Expanded(
                                                child: Text('${item.deviceId}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.001,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Device Type'),
                                              SizedBox(
                                                width: displayWidth(context) *
                                                    0.02,
                                              ),
                                              Text(
                                                '${item.deviceType}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.001,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Device Request'),
                                              SizedBox(
                                                width: displayWidth(context) *
                                                    0.02,
                                              ),
                                              item.approved
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3,
                                                          horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color:
                                                                Colors.green),
                                                        color: Colors.green,
                                                      ),
                                                      child: const Text(
                                                        'Approved',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3,
                                                          horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color:
                                                                primaryColor),
                                                        color: primaryColor,
                                                      ),
                                                      child: const Text(
                                                        'Pending',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.001,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Request Date'),
                                              SizedBox(
                                                width: displayWidth(context) *
                                                    0.02,
                                              ),
                                              Text(
                                                DateUtil.formatStringDate(
                                                    DateFormat.yMMMEd(),
                                                    date: DateTime.parse(
                                                        item.creationDate)),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    }),
                          );
                  },
                )

                // ListView(
                //   children: [
                //     Text('hello'),
                //     Text('hello'),
                //     Text('hello'),
                //     Text('hello')
                //   ],
                // ),
                ),
          ),
        ]),
      ),
    );
  }
}
