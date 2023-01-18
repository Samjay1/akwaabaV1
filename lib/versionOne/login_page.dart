import 'package:akwaaba/components/bottom_border_textfield.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/providers/client_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/screens/forgot_password_page.dart';
import 'package:akwaaba/versionOne/member_registration_page_organization.dart';
import 'package:akwaaba/versionOne/RegistrationCode.dart';
import 'package:akwaaba/versionOne/main_page.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../dialogs_modals/confirm_dialog.dart';
import '../providers/client_provider.dart';
import 'member_registration_page_individual.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerAdminEmail = TextEditingController();
  final TextEditingController _controllerAdminPassword =
      TextEditingController();
  bool showPassword = true;
  double screenHeight = 0;
  double screenWidth = 0;
  // final _formKey = GlobalKey<FormState>();
  // bool _adminLogin=false;//is user logging in as admin or member?false = member login
  String email = "";
  String password = "";

  @override
  late BuildContext context;

  MemberProvider? _memberProvider;
  ClientProvider? _clientProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _memberProvider = context.watch<MemberProvider>();
    _clientProvider = context.watch<ClientProvider>();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    this.context = context;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.45,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              // physics: const BouncingScrollPhysics(),
              children: [
                //const SizedBox(height: 56,),
                CircleAvatar(
                  radius: 130,
                  backgroundColor: Colors.grey.shade100,
                  child: Image.asset(
                    "images/logo_transparent.png",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),

                // const Text("Login to continue",textAlign: TextAlign.center,
                //   style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600),),

                const SizedBox(
                  height: 12,
                ),

                DefaultTabController(
                  length: 2, // Added
                  initialIndex: 0,
                  child: Card(
                    elevation: 8,
                    color: Colors.grey.shade900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 450,
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child: Column(
                        children: [
                          TabBar(
                              labelColor: primaryColor,
                              unselectedLabelColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: Colors.grey.shade800),

                              //indicatorColor: primaryColor,
                              tabs: const [
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Member"),
                                  ),
                                ),
                                Tab(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("Admin"),
                                  ),
                                ),
                              ]),
                          Expanded(
                            child: TabBarView(children: [
                              memberLoginView(),
                              // memberLoginView()
                              adminLoginView()
                            ]),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WebViewPage(
                                  url:
                                  'https://akwaabasolutions.com/about-akwaaba-software/',
                                  title: 'About Akwaaba'),
                            ),
                          );

                          // Navigator.push(context, MaterialPageRoute(builder: (_)=>
                          // const ForgotPasswordPage()));
                        },
                        child: const Text(
                          "About Akwaaba",
                          style: TextStyle(color: Colors.white,),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget memberLoginView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 12,
        ),
        // _loginFields(),
        BottomBorderTextField(
          controller: _controllerEmail,
          label: "Email or Phone",
          iconData: Icons.person,
          textColor: Colors.white,
        ),

        const SizedBox(
          height: 8,
        ),

        BottomBorderTextField(
          controller: _controllerPassword,
          label: "Password",
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.done,
          iconData: Icons.lock,
          suffixTapFunction: () {
            hideOrShowPassword();
          },
          obscure: showPassword,
          textColor: Colors.white,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot Password ?",
                  style: TextStyle(color: Colors.blue),
                )),
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        Consumer<MemberProvider>(
          builder: (context, data, child) {
            return CustomElevatedButton(
              label: "Login",
              function: () {
                _memberProvider!.validateInputFields(
                  context: context,
                  isAdmin: false,
                  phoneEmail: _controllerEmail.text.trim(),
                  password: _controllerPassword.text.trim(),
                );
                //login(isAdmin: false);
              },
              showProgress: data.loading,
            );
          },
        ),

        const SizedBox(
          height: 24,
        ),

        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                      text: ' Sign up now',
                      style: const TextStyle(color: primaryColor, fontSize: 17),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: ConfirmDialog(
                                title: 'Registration Form',
                                content:
                                    'Create a Member account or an Organisation account!',
                                onConfirmTap: () {
                                  Navigator.pop(context); //close the popup
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            RegistrationCode(regType: 'member'),
                                      ));
                                },
                                onCancelTap: () {
                                  Navigator.pop(context); //close the popup
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RegistrationCode(
                                          regType: 'organiser'),
                                    ),
                                  );
                                },
                                confirmText: 'Member',
                                cancelText: 'Organisation',
                              ),
                            ),
                          );

                        })
                ]),
          ),
        ),
      ],
    );
  }

  Widget adminLoginView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 12,
        ),
        // _loginFields(),
        BottomBorderTextField(
          controller: _controllerAdminEmail,
          label: "Email or Phone",
          iconData: Icons.person,
          textColor: Colors.white,
        ),

        const SizedBox(
          height: 8,
        ),

        BottomBorderTextField(
          controller: _controllerAdminPassword,
          label: "Password",
          textInputType: TextInputType.text,
          textInputAction: TextInputAction.done,
          iconData: Icons.lock,
          suffixTapFunction: () {
            hideOrShowPassword();
          },
          obscure: showPassword,
          textColor: Colors.white,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WebViewPage(
                          url:
                              'https://password-reset.akwaabasoftware.com/client-user/forgot-password',
                          title: 'Forgot Password '),
                    ),
                  );

                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>
                  // const ForgotPasswordPage()));
                },
                child: const Text(
                  "Forgot Password ?",
                  style: TextStyle(color: Colors.blue),
                )),
          ),
        ),

        const SizedBox(
          height: 24,
        ),
        Consumer<ClientProvider>(
          builder: (context, data, child) {
            return CustomElevatedButton(
              label: "Login",
              function: () {
                _clientProvider!.validateInputFields(
                  context: context,
                  isAdmin: true,
                  phoneEmail: _controllerAdminEmail.text.trim(),
                  password: _controllerAdminPassword.text.trim(),
                );
              },
              showProgress: data.loading,
            );
          },
        )
      ],
    );
  }

  hideOrShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  createAccountButtonTap() {
    //member register, //client registration
  }
}
