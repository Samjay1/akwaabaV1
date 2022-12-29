import 'dart:convert';
import 'package:akwaaba/Networks/member_api.dart';
import 'package:akwaaba/components/bottom_border_textfield.dart';
import 'package:akwaaba/components/custom_elevated_button.dart';
import 'package:akwaaba/models/members/member_profile.dart';
import 'package:akwaaba/providers/general_provider.dart';
import 'package:akwaaba/providers/member_provider.dart';
import 'package:akwaaba/screens/forgot_password_page.dart';
import 'package:akwaaba/versionOne/main_page.dart';
import 'package:akwaaba/versionOne/webview_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/shared_prefs.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';
import 'member_registration_page_individual.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail= TextEditingController();
  final TextEditingController _controllerPassword= TextEditingController();
  final TextEditingController _controllerAdminEmail= TextEditingController();
  final TextEditingController _controllerAdminPassword= TextEditingController();
  bool showPassword =false;
  bool showProgressIndicator = false;
  bool showAdminProgressIndicator=false;
  double screenHeight=0;
  double screenWidth=0;
  // final _formKey = GlobalKey<FormState>();
 // bool _adminLogin=false;//is user logging in as admin or member?false = member login
  String email = "";
  String password = "";

  @override
  late BuildContext context;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    this.context = context;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar:PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children:  [

          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: screenHeight*0.45,
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
                    child: Image.asset("images/logo_transparent.png",),
                  ),
                  const SizedBox(height: 8,),

                  // const Text("Login to continue",textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600),),

                  const SizedBox(height: 12,),

                  DefaultTabController(
                    length: 2,  // Added
                    initialIndex: 0,
                    child: Card(
                      elevation: 8,
                      color: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Container(
                        height: 450,
                        padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),

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
                              child: TabBarView(
                                  children: [
                                    memberLoginView(),
                                    // memberLoginView()
                                    adminLoginView()
                                  ]),
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),


        ],
      ),
    );
  }


  Widget memberLoginView(){
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        const SizedBox(height: 12,),
        // _loginFields(),
        BottomBorderTextField(
          controller: _controllerEmail,
          label: "Email or Phone",
          iconData: Icons.person,  textColor: Colors.white,),

        const SizedBox(height: 8,),

        BottomBorderTextField(controller: _controllerPassword, label: "Password",
          textInputType: TextInputType.text,textInputAction: TextInputAction.done,
          iconData: Icons.lock,suffixTapFunction: (){hideOrShowPassword();},
          obscure: showPassword,
          textColor: Colors.white,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>
              const ForgotPasswordPage()));
            },
                child: const Text("Forgot Password ?",
                  style: TextStyle(color: Colors.blue),)),
          ),
        ),

        const SizedBox(height: 24,),



        CustomElevatedButton(
          label: "Login",
          function: (){login(isAdmin: false);},
          showProgress: showProgressIndicator,),


        const SizedBox(height: 24,),

        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(
                    color: Colors.grey  , fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: ' Sign up now',
                      style: const TextStyle(
                          color: primaryColor, fontSize: 17),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>const MemberRegistrationPageIndividual()));
                          // createAccountButtonTap();
                        }
                  )
                ]
            ),
          ),
        ),
      ],
    );
  }

  Widget adminLoginView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12,),
        // _loginFields(),
        BottomBorderTextField(
          controller: _controllerAdminEmail,
          label: "Email or Phone",
          iconData: Icons.person,  textColor: Colors.white,),

        const SizedBox(height: 8,),

        BottomBorderTextField(controller: _controllerAdminPassword, label: "Password",
          textInputType: TextInputType.text,textInputAction: TextInputAction.done,
          iconData: Icons.lock,suffixTapFunction: (){hideOrShowPassword();},
          obscure: showPassword,
          textColor: Colors.white,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                 const WebViewPage(
                      url: 'https://password-reset.akwaabasoftware.com/client-user/forgot-password',
                      title: 'Forgot Password ')));

              // Navigator.push(context, MaterialPageRoute(builder: (_)=>
              // const ForgotPasswordPage()));
            },
                child: const Text("Forgot Password ?",
                  style: TextStyle(color: Colors.blue),)),
          ),
        ),

        const SizedBox(height: 24,),
        Consumer<ClientProvider>(
          builder: (context,data,child){
            return CustomElevatedButton(label: "Login",
              function: (){
                login(isAdmin: true);
              },
              showProgress: data.showLoginProgressIndicator,
            );
          },
        )
      ],
    );
  }

  hideOrShowPassword(){
    setState(() {
      showPassword=!showPassword;
    });
  }



  login({required bool isAdmin}) {
    FocusManager.instance.primaryFocus?.unfocus();//hide keyboard

    //check inputs
    if(isAdmin){
      if(_controllerAdminEmail.text.trim().isEmpty){
        showErrorSnackBar(context, "Please input your email address");
        return;
      }
      if(_controllerAdminPassword.text.trim().isEmpty){
        showErrorSnackBar(context, "Please input your password");
        return;
      }

       email = _controllerAdminEmail.text.trim();
       password = _controllerAdminPassword.text.trim();
    }
    else{
      if(_controllerEmail.text.trim().isEmpty){
        showErrorSnackBar(context, "Please input your email address");
        return;
      }
      if(_controllerPassword.text.trim().isEmpty){
        showErrorSnackBar(context, "Please input your password");
        return;
      }

       email = _controllerEmail.text.trim();
       password = _controllerPassword.text.trim();

       //save password and email in shared prefs
    }

      //show progress indicator
    setState(() {
      showProgressIndicator=true;
    });

      if(isAdmin){
        Provider.of<ClientProvider>(context,listen: false).login(context: context,phoneEmail: email, password: password).then((value) {
          setState(() {
            showProgressIndicator=false;
            Provider.of<GeneralProvider>(context,listen: false).
            setAdminStatus(isAdmin: true);
          });


        }).catchError((e){
          showErrorToast("$e");
          setState(() {
            showProgressIndicator=false;
          });
        });


        SharedPrefs().setUserType(userType: "admin");
        SharedPrefs().saveLoginCredentials(emailOrPhone: email, password: password);

      }else{

        setState(() {
          showProgressIndicator=true;
        });

        Provider.of<MemberProvider>(context,listen: false).login(context: context,phoneEmail: email, password: password, checkDeviceInfo: false).then((value) {
          setState(() {
            showProgressIndicator=false;
            Provider.of<GeneralProvider>(context,listen: false).
            setAdminStatus(isAdmin: false);
          });


        }).catchError((e){
          showErrorToast("$e");
          setState(() {
            showProgressIndicator=false;
          });
        });

        SharedPrefs().setUserType(userType: "member");
        SharedPrefs().saveLoginCredentials(emailOrPhone: email, password: password);
        //

        // MemberAPI().userLogin(phoneEmail: email, password: password,
        //     checkDeviceInfo: false).
        // then((value) {
        //   setState(() {
        //     showProgressIndicator=false;
        //   });
        //   if(value.isNotEmpty){
        //     try{
        //       Map decodedResponse = json.decode(value);
        //       var token = decodedResponse["token"];
        //       MemberProfile memberProfile = MemberProfile.fromJson(decodedResponse["user"]);
        //
        //       Provider.of<MemberProvider>(context,listen: false).setToken(token: token);
        //       Provider.of<MemberProvider>(context,listen: false).setMemberProfileInfo(memberProfile: memberProfile);
        //
        //       SharedPrefs().setUserType(userType: "member");
        //       SharedPrefs().saveLoginCredentials(emailOrPhone: email, password: password);
        //       SharedPrefs().saveMemberInfo(memberProfile: memberProfile);
        //
        //       Navigator.push(context, MaterialPageRoute(builder: (_)=>const MainPage()));
        //     }catch(e){
        //       debugPrint("Login error caught ~ $e");
        //
        //     }
        //   }else{
        //     //if the response is empty, a toast would be shown from function making
        //     // the api call
        //   }
        // }).catchError((e){
        //   showErrorToast("$e");
        //     setState(() {
        //       showProgressIndicator=false;
        //     });
        // });


      }
  }

  createAccountButtonTap(){
    //member register, //client registration
  }
}
