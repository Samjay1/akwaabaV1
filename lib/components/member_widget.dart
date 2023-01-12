import 'package:akwaaba/versionOne/all_events_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/my_account_page.dart';
import '../utils/widget_utils.dart';
import '../versionOne/member_account_page.dart';

class MemberWidget extends StatefulWidget {
  const MemberWidget({Key? key}) : super(key: key);

  @override
  State<MemberWidget> createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const MemberAccountPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultRadius)),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            // margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(defaultRadius)),
            child: Row(
              children: [
                defaultProfilePic(height: 50),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: const Text(
                          "Frank Cudjoe Asante",
                          style: TextStyle(fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showNormalToast("Phone icon tapped");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "images/icons/phone_ic.svg",
                                  width: 20,
                                  height: 20,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showNormalToast("Whatsapp icon tapped");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "images/icons/whatsapp_ic.svg",
                                  width: 20,
                                  height: 20,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Profession",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textColorLight),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Group/Dept",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: textColorLight))
                      ],
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
