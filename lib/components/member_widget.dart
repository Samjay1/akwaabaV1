import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/versionOne/all_events_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/admin/clocked_member.dart';
import '../versionOne/my_account_page.dart';
import '../utils/widget_utils.dart';
import '../versionOne/member_account_page.dart';
import 'custom_cached_image_widget.dart';

class MemberWidget extends StatefulWidget {
  final Member? member;
  const MemberWidget({Key? key, this.member}) : super(key: key);

  @override
  State<MemberWidget> createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  String? userType;

  @override
  void initState() {
    getUserType();
    super.initState();
  }

  void getUserType() async {
    userType = await SharedPrefs().getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: widget.member!.selected! ? 3 : 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          // margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: widget.member!.selected!
                  ? Colors.orange.shade100
                  : Colors.white,
              borderRadius: BorderRadius.circular(defaultRadius)),
          child: Row(
            children: [
              Icon(
                widget.member!.selected!
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.checkmark_alt_circle,
                color: widget.member!.selected! ? primaryColor : Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              widget.member!.profilePicture != null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: widget.member!.profilePicture!,
                        height: 50,
                      ),
                    )
                  : defaultProfilePic(height: 50),
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
                          child: Text(
                        "${widget.member!.firstname!.capitalize()} ${widget.member!.surname!.capitalize()}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        //overflow: TextOverflow.ellipsis,
                      )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => openEmailAppWithSubject(
                                widget.member!.email,
                                'SUBJECT',
                                "Hello ${widget.member!.firstname!},"),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                "images/icons/email_ic.svg",
                                width: 20,
                                height: 20,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => makePhoneCall(widget.member!.phone!),
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
                            onTap: () => openWhatsapp(
                                context, widget.member!.phone!, "Hello"),
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
                    children: [
                      Text(
                        widget.member!.identification!,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: textColorLight),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        widget.member!.categoryInfo!.category!,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: textColorLight),
                      )
                    ],
                  )
                ],
              )),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MemberAccountPage(
                        member: widget.member,
                        userType: userType,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
