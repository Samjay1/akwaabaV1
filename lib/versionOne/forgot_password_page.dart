import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/components/form_textfield.dart';
import 'package:akwaaba/components/label_widget_container.dart';
import 'package:akwaaba/models/general/account_type.dart';
import 'package:akwaaba/providers/auth_provider.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<AuthProvider>(context, listen: false).getAccountTypes();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                "images/illustrations/password.svg",
                height: 130,
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              LabelWidgetContainer(
                label: "Member Type",
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 0.0, color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonFormField<AccountType>(
                    isExpanded: true,
                    style: const TextStyle(
                      color: textColorPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    hint: const Text('Select Member Type'),
                    decoration: const InputDecoration(border: InputBorder.none),
                    value: _authProvider.selectedAccountType,
                    icon: Icon(
                      CupertinoIcons.chevron_up_chevron_down,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
                    // Array list of items
                    items: _authProvider.accountTypes
                        .map((AccountType accountType) {
                      return DropdownMenuItem(
                        value: accountType,
                        child: Text(accountType.name!),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _authProvider.selectedAccountType = val as AccountType;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.03,
              ),
              FormTextField(
                controller: _authProvider.emailTEC,
                label: "Email Address",
              ),
              SizedBox(
                height: displayHeight(context) * 0.02,
              ),
              CustomElevatedButton(
                label: "Submit",
                showProgress: _authProvider.loading,
                function: () => _authProvider.validateField(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
