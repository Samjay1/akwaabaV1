import 'package:akwaaba/utils/size_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? text;
  const EmptyStateWidget({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          SvgPicture.asset(
            'images/illustrations/no_data.svg',
            height: 100,
          ),
          SizedBox(
            height: displayHeight(context) * 0.02,
          ),
          Text(
            text!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }
}
