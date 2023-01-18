import 'package:akwaaba/components/custom_tab_widget.dart';
import 'package:akwaaba/components/empty_state_widget.dart';
import 'package:akwaaba/components/event_shimmer_item.dart';
import 'package:akwaaba/components/member_widget.dart';
import 'package:akwaaba/components/pagination_loader.dart';
import 'package:akwaaba/providers/members_provider.dart';
import 'package:akwaaba/versionOne/filter_members_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final TextEditingController _controllerSearch = TextEditingController();

  late MembersProvider _membersProvider;

  int _selectedIndex = 0;

  void loadAllMembers() async {
    Future.delayed(Duration.zero, () {
      // load all upcoming events or meetings
      Provider.of<MembersProvider>(context, listen: false)
          .getAllIndividualMembers();
      setState(() {});
    });
  }

  @override
  initState() {
    super.initState();
    loadAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    _membersProvider = context.watch<MembersProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _membersProvider.refreshList(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      onChanged: (val) {
                        if (val.isEmpty) {
                          _membersProvider.isFilter =
                              false; // update filter flag
                          _membersProvider.search = val;
                        }
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _membersProvider.search = value;
                        });
                        _membersProvider.isFilter = true; // update filter flag
                        _selectedIndex == 0
                            ? _membersProvider.getAllIndividualMembers()
                            : _membersProvider.getAllOrganizationalMembers();
                        debugPrint('Search: ${_membersProvider.search}');
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FilterMembersPage(
                                    selectedIndex: _selectedIndex)));
                      },
                      icon: const Icon(
                        Icons.filter_alt,
                        color: primaryColor,
                      ))
                ],
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              CustomTabWidget(
                selectedIndex: _selectedIndex,
                tabTitles: const [
                  'Individual',
                  'Organization',
                ],
                onTaps: [
                  () {
                    setState(() {
                      _selectedIndex = 0;

                      ///checkAll = false;

                      debugPrint('Selected Index: $_selectedIndex');
                    });
                  },
                  () {
                    setState(() {
                      _selectedIndex = 1;
                      //checkAll = false;

                      debugPrint('Selected Index: $_selectedIndex');
                    });
                  },
                ],
              ),
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
                  : _selectedIndex == 0
                      ? Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _membersProvider.refreshList(),
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
                            onRefresh: () => _membersProvider.refreshList(),
                            child: Column(
                              children: [
                                _membersProvider.organizationalMembers.isEmpty
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
                                              .orgMembersScrollController,
                                          itemCount: _membersProvider
                                              .organizationalMembers.length,
                                          itemBuilder: (context, index) {
                                            return MemberWidget(
                                              member: _membersProvider
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
                        )
            ],
          ),
        ),
      ),
    );
  }
}
