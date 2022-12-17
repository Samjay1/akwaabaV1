import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/dimens.dart';

class MessageManagerMenuWidget extends StatefulWidget {
  final String menuName;
  final VoidCallback function;
  const MessageManagerMenuWidget({
  required this.menuName,required this.function
  ,Key? key}) : super(key: key);

  @override
  State<MessageManagerMenuWidget> createState() => _MessageManagerMenuWidgetState();
}

class _MessageManagerMenuWidgetState extends State<MessageManagerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,

      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 16),
              decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius),
                      bottomLeft:Radius.circular(defaultRadius) )
              ),
              child: const Icon(Icons.circle,color: Colors.white,size: 16,),
            ),
            const SizedBox(width: 8,),
            Expanded(child: Text("${widget.menuName}")),
            const Icon(Icons.chevron_right,color: primaryColor,)
          ],
        ),
      ),
    );
  }
}
