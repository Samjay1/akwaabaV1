import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

  void loadToken({var memberId}) async {
    prefs = await SharedPreferences.getInstance();
    memberToken = prefs?.getString('token');
    Provider.of<MemberProvider>(context, listen: false).callDeviceRequestList(
        memberToken: memberToken, memberID: memberId, context: context);
    print('DEVICE ACTIVATION TOKEN ${memberToken}');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //GETS MEMBER PROFILE INFO
    MemberProfile memberProfile =
        Provider.of<MemberProvider>(context, listen: false).memberProfile;
    var memberId = memberProfile.user!.id; // GETS THE MEMBER ID

    //GETS DEVICE INFO
    var deviceInfo =
        Provider.of<MemberProvider>(context, listen: false).deviceInfoModel;

    //GETS TOKEN AND LOADS DEVICE REQUEST LIST
    loadToken(memberId: memberId);
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
                  function: () {
                    MemberAPI api = MemberAPI();
                    api.requestDeviceActivation(
                        memberId: memberId,
                        systemDevice: deviceInfo?.systemDevice,
                        deviceType: deviceInfo?.deviceType,
                        deviceId: deviceInfo?.deviceId);
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
                    return data.deviceRequestList != null
                        ? RefreshIndicator(
                            onRefresh: () => Provider.of<MemberProvider>(
                                    context,
                                    listen: false)
                                .callDeviceRequestList(
                                    memberToken: memberToken,
                                    memberID: memberId,
                                    context: context),
                            child: ListView.builder(
                                itemCount: data.deviceRequestList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var item = data.deviceRequestList[index];
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Device ID'),
                                          Text('${item.deviceId}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Device Type'),
                                          Text(
                                            '${item.deviceType}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Device Request'),
                                          item.approved
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    color: Colors.green,
                                                  ),
                                                  child: const Text(
                                                      'Device Approved'),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.orange),
                                                    color: Colors.orange,
                                                  ),
                                                  child: const Text(
                                                      'Approval Pending'),
                                                )
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.orange,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                }),
                          )
                        : const Center(child: CircularProgressIndicator());
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
