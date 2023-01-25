import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/member_widget.dart';
import 'package:akwaaba/components/organization_widget.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/constants/app_dimens.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'filter_page.dart';

class MembersPage extends StatefulWidget {
  final bool isMemberuser;
  const MembersPage({required this.isMemberuser, Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late MembersProvider _membersProvider;

  void loadAllMembers() async {
    Future.delayed(Duration.zero, () {
      Provider.of<MembersProvider>(context, listen: false)
          .setCurrentContext(context);
      // load individual or organization members
      widget.isMemberuser
          ? Provider.of<MembersProvider>(context, listen: false)
              .getAllIndividualMembers()
          : Provider.of<MembersProvider>(context, listen: false)
              .getAllOrganizations();
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
                    onChanged: (val) {
                      if (val.isEmpty) {
                        _membersProvider.search = val;
                        widget.isMemberuser
                            ? _membersProvider.getAllIndividualMembers()
                            : _membersProvider.getAllOrganizations();
                      }
                    },
                    onSubmitted: (value) {
                      setState(() {
                        _membersProvider.search = value;
                      });

                      widget.isMemberuser
                          ? _membersProvider.getAllIndividualMembers()
                          : _membersProvider.getAllOrganizations();
                      debugPrint('Search: ${_membersProvider.search}');
                    },
                  ),
                ),
                IconButton(
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

            SizedBox(
              height: displayHeight(context) * 0.02,
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
                : widget.isMemberuser
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => _membersProvider.refreshList(
                              isMember: widget.isMemberuser),
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
                                        physics: const BouncingScrollPhysics(),
                                        controller: _membersProvider
                                            .indMembersScrollController,
                                        itemCount: _membersProvider
                                            .individualMembers.length,
                                        itemBuilder: (context, index) {
                                          return MemberWidget(
                                            member: _membersProvider
                                                .individualMembers[index],
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
                              isMember: widget.isMemberuser),
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
                                        physics: const BouncingScrollPhysics(),
                                        controller: _membersProvider
                                            .orgMembersScrollController,
                                        itemCount: _membersProvider
                                            .organizationalMembers.length,
                                        itemBuilder: (context, index) {
                                          return OrganizationWidget(
                                            organization: _membersProvider
                                                .organizationalMembers[index],
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
