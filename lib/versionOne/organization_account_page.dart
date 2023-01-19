import 'package:akwaaba/models/general/organization.dart';
import 'package:akwaaba/screens/update_account_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/date_utils.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../components/custom_cached_image_widget.dart';
import '../models/admin/clocked_member.dart';

class OrganizationAccountPage extends StatefulWidget {
  final Organization? organization;
  const OrganizationAccountPage({Key? key, required this.organization})
      : super(key: key);

  @override
  State<OrganizationAccountPage> createState() =>
      _OrganizationAccountPageState();
}

class _OrganizationAccountPageState extends State<OrganizationAccountPage> {
  Color dividerColor = Colors.grey.shade300;
  double dividerHeight = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            //header
            SliverAppBar(
              // backgroundColor: primaryColor,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                // statusBarIconBrightness: Brightness.light, // For Android (dark icons)
                // statusBarBrightness: Brightness.dark, // For iOS (dark icons)
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [headerView()],
                ),
              ),
              automaticallyImplyLeading: true,
              floating: true,
              pinned: true,
              expandedHeight: 300,
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //padding: EdgeInsets.all(16),
            children: [
              Container(
                height: dividerHeight,
                color: dividerColor,
              ),
              profileItemView(
                  title: "Branch",
                  label: widget.organization!.branchInfo == null
                      ? "N/A"
                      : widget.organization!.branchInfo!.name!,
                  display: true),

              profileItemView(
                  title: "Contact Email",
                  label: widget.organization!.contactPersonEmail == null
                      ? "N/A"
                      : widget.organization!.contactPersonEmail!,
                  display: true),
              profileItemView(
                  title: "Contact Phone",
                  label: widget.organization!.contactPersonPhone == null
                      ? "N/A"
                      : widget.organization!.contactPersonPhone!,
                  display: true),
              profileItemView(
                  title: "Business Status",
                  label: widget.organization!.businessRegistered!
                      ? "Registered"
                      : 'Unregistered',
                  display: true),

              profileItemView(
                  title: "Date of Incorporation",
                  label: widget.organization!.dateOfIncorporation == null
                      ? 'N/A'
                      : widget.organization!.dateOfIncorporation!),
              profileItemView(
                  title: "Date Joined",
                  label: DateUtil.formatStringDate(DateFormat.yMMMEd(),
                      date: DateTime.parse(widget.organization!.date!))),
              const SizedBox(
                height: 24,
              ),
              // Container(
              //   height: dividerHeight,
              //   color: dividerColor,
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              // const Padding(
              //   padding: EdgeInsets.only(left: 16),
              //   child: Text(
              //     "Group",
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              //   ),
              // ),
              // profileItemView(title: "Group", label: "N/A"),
              // profileItemView(title: "Sub Group", label: "N/A"),
              // const SizedBox(
              //   height: 24,
              // ),
              Container(
                height: dividerHeight,
                color: dividerColor,
              ),
              const SizedBox(
                height: 24,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Location",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              profileItemView(
                  title: "Coutry",
                  label: widget.organization!.countryOfBusiness == null
                      ? 'N/A'
                      : widget.organization!.countryOfBusiness!),
              profileItemView(
                  title: "State / Province",
                  label: widget.organization!.stateProvince == null
                      ? 'N/A'
                      : widget.organization!.stateProvince!),
              profileItemView(
                  title: "Region",
                  label: widget.organization!.regionInfo == null
                      ? 'N/A'
                      : widget.organization!.regionInfo!.location!),
              profileItemView(
                  title: "District",
                  label: widget.organization!.districtInfo == null
                      ? 'N/A'
                      : widget.organization!.districtInfo!.location!),
              profileItemView(
                  title: "Constituency",
                  label: widget.organization!.constituencyInfo == null
                      ? 'N/A'
                      : widget.organization!.constituencyInfo!.location!),
              profileItemView(
                  title: "Electoral Area",
                  label: widget.organization!.electoralareaInfo == null
                      ? 'N/A'
                      : widget.organization!.electoralareaInfo!.location!),
              profileItemView(
                  title: "Community",
                  label: widget.organization!.community == null
                      ? 'N/A'
                      : widget.organization!.community!.toString()),

              // profileItemView(
              //     title: "Residential Area",
              //     label: widget.member!.countryOfResidence!.toString()),
              profileItemView(
                  title: "Digital Address",
                  label: widget.organization!.digitalAddress == null
                      ? 'N/A'
                      : widget.organization!.digitalAddress!),
              const SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget headerView() {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 175,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 45,
                  child: Container(
                    decoration: const BoxDecoration(color: primaryColor),
                  ),
                ),
                Positioned(
                  top: 70,
                  child: widget.organization!.logo != null
                      ? Align(
                          child: CustomCachedImageWidget(
                            url: widget.organization!.logo!,
                            height: 100,
                          ),
                        )
                      : defaultProfilePic(height: 100),
                )
              ],
            ),
          ),
          Text(
            widget.organization!.organizationName!,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: textColorPrimary,
                fontSize: 20),
          ),
          const SizedBox(
            height: 12,
          ),
          Text("ID : ${widget.organization!.identification}"),
          const SizedBox(
            height: 6,
          ),
          Text(
              "Status: ${widget.organization!.status == 1 ? 'Active' : 'Inactive'}"),
        ],
      ),
    );
  }

  Widget profileItemView(
      {required String title, required String label, bool display = false}) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const SizedBox(
              width: 12,
            ),
            Row(
              children: [
                Text(label),
                const SizedBox(
                  width: 12,
                ),
                Icon(display ? Icons.visibility : Icons.visibility_off)
              ],
            ),
          ],
        ));
  }
}
