import 'dart:io';

import 'package:akwaaba/constants/app_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterLoader extends StatelessWidget {
  const FilterLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const SizedBox(
            width: AppSize.s14,
            height: AppSize.s14,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          )
        : const CupertinoActivityIndicator(
            radius: 10,
          );
  }
}
