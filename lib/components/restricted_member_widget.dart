import 'package:akwaaba/models/general/restricted_member.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/string_extension.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/widget_utils.dart';
import 'custom_cached_image_widget.dart';

class RestrictedMemberWidget extends StatefulWidget {
  final RestrictedMember? restrictedMember;
  const RestrictedMemberWidget({Key? key, this.restrictedMember})
      : super(key: key);

  @override
  State<RestrictedMemberWidget> createState() => _RestrictedMemberWidgetState();
}

class _RestrictedMemberWidgetState extends State<RestrictedMemberWidget> {
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
        elevation: widget.restrictedMember!.member!.selected! ? 3 : 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius)),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          // margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: widget.restrictedMember!.member!.selected!
                  ? Colors.orange.shade100
                  : Colors.white,
              borderRadius: BorderRadius.circular(defaultRadius)),
          child: Row(
            children: [
              widget.restrictedMember!.member!.profilePicture != null
                  ? Align(
                      child: CustomCachedImageWidget(
                        url: widget.restrictedMember!.member!.profilePicture!,
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
                  widget.restrictedMember!.contacts == null
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => openEmailAppWithSubject(
                                  widget.restrictedMember!.member!.email,
                                  'SUBJECT',
                                  "Hello ${widget.restrictedMember!.member!.firstname!},"),
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
                              onTap: () => makePhoneCall(
                                widget.restrictedMember!.member!.phone!,
                              ),
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
                                context,
                                widget.restrictedMember!.contacts == null
                                    ? widget.restrictedMember!.member!.phone!
                                    : widget.restrictedMember!.contacts!
                                        .contact!.whatsapp!,
                                'Hello there!',
                              ),
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
                        ),
                  SizedBox(
                    height: displayHeight(context) * 0.005,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.restrictedMember!.member!.firstname == null ? '' : widget.restrictedMember!.member!.firstname!} ${(widget.restrictedMember!.member!.middlename == null || widget.restrictedMember!.member!.middlename!.isEmpty) ? '' : widget.restrictedMember!.member!.middlename!.capitalize()} ${widget.restrictedMember!.member!.surname == null ? '' : widget.restrictedMember!.member!.surname!.capitalize()}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: displayHeight(context) * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.restrictedMember!.identification == null
                            ? 'N/A'
                            : widget.restrictedMember!.identification!,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: textColorLight),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      widget.restrictedMember!.member!.categoryInfo == null
                          ? const SizedBox()
                          : Expanded(
                              child: Text(
                                widget.restrictedMember!.member!.categoryInfo!
                                    .category!,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: textColorLight),
                              ),
                            )
                    ],
                  )
                ],
              )),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => RestrictedMemberAccountPage(
              //           restrictedMember: widget.restrictedMember,
              //           userType: userType,
              //         ),
              //       ),
              //     );
              //   },
              //   child: const Icon(
              //     Icons.chevron_right,
              //     size: 20,
              //     color: primaryColor,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
