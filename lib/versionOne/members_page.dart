import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/member_widget.dart';
import 'package:akwaaba/components/organization_widget.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/constants/app_constants.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/dialogs_modals/confirm_dialog.dart';
import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/search_util.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:akwaaba/versionOne/restricted_member_account_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../components/restricted_member_widget.dart';
import 'filter_page.dart';

class MembersPage extends StatefulWidget {
  final bool isMemberuser;
  const MembersPage({required this.isMemberuser, Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late MembersProvider _membersProvider;

  String? userType;

  bool checkAll = false;
  bool itemHasBeenSelected =
      false; // at least 1 member has been selected, so show options menu

  final _debouncer = Debouncer(milliseconds: AppConstants.searchTimerDuration);

  void loadAllMembers() async {
    SharedPrefs().getUserType().then((value) {
      setState(() {
        userType = value!;
      });
    });
    Future.delayed(Duration.zero, () {
      Provider.of<MembersProvider>(context, listen: false)
          .setCurrentContext(context);
      // load individual or organization members
      if (userType == AppConstants.member) {
        widget.isMemberuser
            ? Provider.of<MembersProvider>(context, listen: false)
                .getAllRestrictedMembers()
            : Provider.of<MembersProvider>(context, listen: false)
                .getAllOrganizations();
      } else {
        widget.isMemberuser
            ? Provider.of<MembersProvider>(context, listen: false)
                .getAllIndividualMembers()
            : Provider.of<MembersProvider>(context, listen: false)
                .getAllOrganizations();
      }

      debugPrint("isMemberuser: ${widget.isMemberuser}");
      debugPrint("Type: $userType");

      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    loadAllMembers();
  }

  @override
  void dispose() {
    if (mounted) {
      _membersProvider.clearData();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _membersProvider = context.watch<MembersProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isMemberuser ? 'Members' : 'Organisations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    padding: const EdgeInsets.all(AppPadding.p14),
                    controller: _membersProvider.searchNameTEC,
                    onChanged: (val) {
                      setState(() {
                        _membersProvider.search = val;
                      });
                      _debouncer.run(() {
                        if (userType == AppConstants.admin) {
                          widget.isMemberuser
                              ? _membersProvider.getAllIndividualMembers()
                              : _membersProvider.getAllOrganizations();
                        }
                        if (userType == AppConstants.member) {
                          widget.isMemberuser
                              ? _membersProvider.getAllRestrictedMembers()
                              : _membersProvider.getAllOrganizations();
                        }
                      });
                      debugPrint('Search: ${_membersProvider.search}');
                    },
                    onSubmitted: (val) {
                      setState(() {
                        _membersProvider.search = val;
                      });
                      if (userType == AppConstants.admin) {
                        widget.isMemberuser
                            ? _membersProvider.getAllIndividualMembers()
                            : _membersProvider.getAllOrganizations();
                      }
                      if (userType == AppConstants.member) {
                        widget.isMemberuser
                            ? _membersProvider.getAllRestrictedMembers()
                            // _membersProvider.searchRestrictedMembers(
                            //     searchText: val,
                            //   )
                            : _membersProvider.getAllOrganizations();
                      }
                      debugPrint('Search: ${_membersProvider.search}');
                    },
                  ),
                ),
                (widget.isMemberuser && userType == AppConstants.member)
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FilterPage(isMemberUser: widget.isMemberuser),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.filter_alt,
                          color: primaryColor,
                        )),
              ],
            ),

            filteredSummaryView(isMemberUsers: widget.isMemberuser),

            (userType == AppConstants.admin && widget.isMemberuser)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: primaryColor,
                            shape: const CircleBorder(),
                            value: checkAll,
                            onChanged: (val) {
                              setState(() {
                                checkAll = val!;
                              });

                              for (Member? member
                                  in _membersProvider.individualMembers) {
                                member!.selected = checkAll;
                                if (member.selected!) {
                                  _membersProvider.selectedMemberIds
                                      .add(member.id);
                                }
                                if (!member.selected!) {
                                  _membersProvider.selectedMemberIds
                                      .remove(member.id);
                                }
                              }
                              debugPrint(
                                "Selected Members: ${_membersProvider.selectedMemberIds.toString()}",
                              );
                            },
                          ),
                          const Text("Select All")
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Row(
                        children: [
                          // Enable button
                          InkWell(
                            onTap: () {
                              if (_membersProvider.selectedMemberIds.isEmpty) {
                                showInfoDialog(
                                  'ok',
                                  context: context,
                                  title: 'Sorry!',
                                  content:
                                      'Please select members to perform this operation',
                                  onTap: () => Navigator.pop(context),
                                );
                              } else {
                                // perform bulk clock out
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: ConfirmDialog(
                                      title: 'Enable Profile Editing',
                                      content:
                                          'Are you sure you want to perform \nthis bulk operation?',
                                      onConfirmTap: () async {
                                        Navigator.pop(context);
                                        await _membersProvider
                                            .enableBulkProfileEditing();
                                        setState(() {
                                          checkAll = false;
                                        });
                                      },
                                      onCancelTap: () => Navigator.pop(context),
                                      confirmText: 'Yes',
                                      cancelText: 'Cancel',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: const Text(
                                "Enable",
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: displayWidth(context) * 0.03,
                          ),
                          // disable button
                          InkWell(
                            onTap: () {
                              if (_membersProvider.selectedMemberIds.isEmpty) {
                                showInfoDialog(
                                  'ok',
                                  context: context,
                                  title: 'Sorry!',
                                  content:
                                      'Please select members to perform this operation',
                                  onTap: () => Navigator.pop(context),
                                );
                              } else {
                                // perform bulk clock out
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    content: ConfirmDialog(
                                      title: 'Disable Profile Editing',
                                      content:
                                          'Are you sure you want to perform \nthis bulk operation?',
                                      onConfirmTap: () async {
                                        Navigator.pop(context);
                                        await _membersProvider
                                            .disableBulkProfileEditing();
                                        setState(() {
                                          checkAll = false;
                                        });
                                      },
                                      onCancelTap: () => Navigator.pop(context),
                                      confirmText: 'Yes',
                                      cancelText: 'Cancel',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: const Text(
                                "Disable",
                                style: TextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : const SizedBox(),

            SizedBox(
              height: displayHeight(context) * 0.01,
            ),
            _membersProvider.loading
                ? Expanded(
                    child: Shimmer.fromColors(
                      baseColor: greyColorShade300,
                      highlightColor: greyColorShade100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, __) => const EventShimmerItem(),
                        itemCount: 20,
                      ),
                    ),
                  )
                : (userType == AppConstants.member && widget.isMemberuser)
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => _membersProvider.refreshList(
                            isMember: widget.isMemberuser,
                            userType: userType!,
                          ),
                          child: Column(
                            children: [
                              _membersProvider.restrictedMembers.isEmpty
                                  ? const Expanded(
                                      child: EmptyStateWidget(
                                        text: 'No members found!',
                                      ),
                                    )
                                  : Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        controller: _membersProvider
                                            .restrictedMembersScrollController,
                                        itemCount: _membersProvider
                                            .restrictedMembers.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      RestrictedMemberAccountPage(
                                                    restrictedMember:
                                                        _membersProvider
                                                                .restrictedMembers[
                                                            index]!,
                                                    userType: userType,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: RestrictedMemberWidget(
                                              restrictedMember: _membersProvider
                                                  .restrictedMembers[index]!,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              if (_membersProvider.loadingMore)
                                const PaginationLoader(
                                  loadingText: 'Loading. please wait...',
                                )
                            ],
                          ),
                        ),
                      )
                    : (userType == AppConstants.admin && widget.isMemberuser)
                        ? Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _membersProvider.refreshList(
                                isMember: widget.isMemberuser,
                                userType: userType!,
                              ),
                              child: Column(
                                children: [
                                  _membersProvider.individualMembers.isEmpty
                                      ? const Expanded(
                                          child: EmptyStateWidget(
                                            text: 'No members found!',
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: _membersProvider
                                                .indMembersScrollController,
                                            itemCount: _membersProvider
                                                .individualMembers.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (_membersProvider
                                                        .individualMembers[
                                                            index]!
                                                        .selected!) {
                                                      _membersProvider
                                                          .individualMembers[
                                                              index]!
                                                          .selected = false;
                                                      _membersProvider
                                                          .selectedMemberIds
                                                          .remove(
                                                        _membersProvider
                                                            .individualMembers[
                                                                index]!
                                                            .id,
                                                      );
                                                    } else {
                                                      _membersProvider
                                                          .individualMembers[
                                                              index]!
                                                          .selected = true;
                                                      _membersProvider
                                                          .selectedMemberIds
                                                          .add(
                                                        _membersProvider
                                                            .individualMembers[
                                                                index]!
                                                            .id,
                                                      );
                                                    }
                                                  });
                                                  debugPrint(
                                                    "Selected Members: ${_membersProvider.selectedMemberIds.toString()}",
                                                  );
                                                },
                                                child: MemberWidget(
                                                  member: _membersProvider
                                                      .individualMembers[index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                  if (_membersProvider.loadingMore)
                                    const PaginationLoader(
                                      loadingText: 'Loading. please wait...',
                                    )
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _membersProvider.refreshList(
                                isMember: widget.isMemberuser,
                                userType: userType!,
                              ),
                              child: Column(
                                children: [
                                  _membersProvider.organizationalMembers.isEmpty
                                      ? const Expanded(
                                          child: EmptyStateWidget(
                                            text: 'No organizations found!',
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            controller: _membersProvider
                                                .orgMembersScrollController,
                                            itemCount: _membersProvider
                                                .organizationalMembers.length,
                                            itemBuilder: (context, index) {
                                              return OrganizationWidget(
                                                organization: _membersProvider
                                                        .organizationalMembers[
                                                    index],
                                              );
                                            },
                                          ),
                                        ),
                                  if (_membersProvider.loadingMore)
                                    const PaginationLoader(
                                      loadingText: 'Loading. please wait...',
                                    )
                                ],
                              ),
                            ),
                          ),

            // Expanded(
            //   child: ListView(
            //     physics: const BouncingScrollPhysics(),
            //     children: List.generate(20, (index) {
            //       return MemberWidget();
            //     }),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget filteredSummaryView({required bool isMemberUsers}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isMemberUsers
                      ? _membersProvider.totalIndMembers.toString()
                      : _membersProvider.totalOrgs.toString(),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  isMemberUsers ? 'Males' : 'Registered',
                  style: const TextStyle(
                    fontSize: AppSize.s14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isMemberUsers
                      ? _membersProvider.totalMaleIndMembers.toString()
                      : _membersProvider.totalRegOrgs.length.toString(),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  isMemberUsers ? "Females" : 'Unregistered',
                  style: const TextStyle(
                    fontSize: AppSize.s14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isMemberUsers
                      ? _membersProvider.totalFemaleIndMembers.toString()
                      : _membersProvider.totalUnRegOrgs.length.toString(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
