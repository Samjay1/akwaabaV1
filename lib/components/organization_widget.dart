import 'package:akwaaba/models/general/organization.dart';
import 'package:akwaaba/utils/general_utils.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/versionOne/organization_account_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/widget_utils.dart';
import 'custom_cached_image_widget.dart';

class OrganizationWidget extends StatefulWidget {
  final Organization? organization;
  const OrganizationWidget({Key? key, this.organization}) : super(key: key);

  @override
  State<OrganizationWidget> createState() => _OrganizationWidgetState();
}

class _OrganizationWidgetState extends State<OrganizationWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OrganizationAccountPage(organization: widget.organization),
          ),
        );
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
                widget.organization!.logo != null
                    ? Align(
                        child: CustomCachedImageWidget(
                          url: widget.organization!.logo!,
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
                          widget.organization!.organizationName!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => makePhoneCall(
                                  widget.organization!.organizationPhone!),
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
                                  widget.organization!.organizationPhone!,
                                  "Hello"),
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
                          widget.organization!.organizationType!.type!,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textColorLight),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.organization!.categoryInfo!.category!,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textColorLight),
                        )
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
