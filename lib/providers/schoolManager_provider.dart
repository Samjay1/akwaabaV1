
import 'package:akwaaba/models/client_model.dart';
import 'package:akwaaba/models/school_manager/assessmentType_model.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Networks/schoolManager_api.dart';

class SchoolProvider extends ChangeNotifier {
  String? _schoolToken ;
  var _assessmentTypeList;



  get getSchoolToken => _schoolToken;
  get getAssessmentTypeList => _assessmentTypeList;

  Future<void> login({required BuildContext context, var email, var password, role}) async {
    debugPrint('PROVIDER School LOGIN');
    SchoolManagerApi().login(email: email, password: password,role: role).
    then((value){
      if(value=='login_error'){
        showErrorSnackBar(context, "Incorrect student Login Details - Restart app");
        return;
      }else if(value == 'network_error'){
        showErrorSnackBar(context, "Network Issue");
        return;
      }else{
        _schoolToken = value;
        notifyListeners();
      }
    });
  }

  Future<void> assessmentList() async {
    debugPrint('PROVIDER School Assessment');
    SchoolManagerApi().AssessmentTypeApi().
    then((value){
      if(value.isEmpty){
        return;
      }else{
        print('TESTING');
        print(value[0].assessment_type);
        _assessmentTypeList = value;
        notifyListeners();
      }
    });
  }

}