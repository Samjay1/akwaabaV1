import 'dart:io';

import 'package:akwaaba/components/custom_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PaginationLoader extends StatelessWidget {
  final String? loadingText;
  const PaginationLoader({super.key, this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: Column(
          children: [
            Platform.isIOS
                ? const CupertinoActivityIndicator(
                    radius: 18,
                  )
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              loadingText!,
            ),
          ],
        ),
      ),
    );
  }
}
