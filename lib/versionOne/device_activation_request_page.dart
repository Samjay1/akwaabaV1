import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';

import '../models/members/member_profile.dart';

class DeviceActivationRequestPage extends StatefulWidget {
  const DeviceActivationRequestPage({Key? key}) : super(key: key);

  @override
  State<DeviceActivationRequestPage> createState() => _DeviceActivationRequestPageState();
}

class _DeviceActivationRequestPageState extends State<DeviceActivationRequestPage> {
  final TextEditingController _controllerEmailAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    MemberProfile memberProfile = Provider.of<MemberProvider>(context,listen: false).memberProfile;
    var memberId = memberProfile.id;
    var memberToken = memberProfile.memberToken;

    debugPrint('MEMBER INFO ____ ${memberProfile.id}');
    debugPrint('MEMBER memberToken ____ ${memberProfile.memberToken}');

    var deviceInfo = Provider.of<MemberProvider>(context,listen: false).deviceInfoModel;

    Provider.of<MemberProvider>(context,listen: false).callDeviceRequestList(memberToken: memberToken, memberID: memberId, context: context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Activation"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          // decoration: BoxDecoration(color: Colors.orange),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                 height: height*0.3,
                 child: Column(

                   children: [
                     LabelWidgetContainer(label: "Device Type",
                         child: Text("${deviceInfo?.deviceType}")),

                     const SizedBox(height: 20,),

                     LabelWidgetContainer(label: "Device ID",
                         child: Text("${deviceInfo?.deviceId}")),

                     const SizedBox(height: 36,),

                     CustomElevatedButton(label: "Request Activation", function: (){
                       MemberAPI api = MemberAPI();
                       api.requestDeviceActivation(memberId: memberId, systemDevice: deviceInfo?.systemDevice, deviceType: deviceInfo?.deviceType, deviceId: deviceInfo?.deviceId);
                     })
                     ,
                   ],
                 ),
               ),
              Container(
                height: height*0.7,
                color: Colors.blue,
                child: Consumer<MemberProvider>(
                  builder: (context, data, child){
                    return data.deviceRequestList!= null ?  ListView.builder(
                        itemCount: data.deviceRequestList.length,
                        itemBuilder: (context, index){
                          return Column(
                            children:const [
                               Text('hello')
                            ],
                          );
                      }
                    ): const Center(child: CircularProgressIndicator());
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



            ]
        ),
        ),
      ),
    );
  }



}
