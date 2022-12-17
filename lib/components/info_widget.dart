import 'package:akwaaba/screens/info_center_page.dart';
import 'package:akwaaba/screens/info_center_post_view_page.dart';
import 'package:akwaaba/screens/new_post_page.dart';
import 'package:akwaaba/utils/app_theme.dart';
import 'package:akwaaba/utils/dimens.dart';
import 'package:akwaaba/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({Key? key}) : super(key: key);

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>
          InfoCenterPostViewPage()));
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius)
          ),
          child: Container(
            margin: const EdgeInsets.all(8),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    defaultProfilePic(height: 50),
                    Column(
                      children: const [
                        Text("Tema General Hospital",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),

                      ],
                    )
                  ],
                ),
                const SizedBox(height: 6,),
                const Text("Memo: Attendance Clocking App",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                const SizedBox(height: 12,),
                const Text("$loremIpsum",
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColorLight,fontSize: 15
                ),),


                const SizedBox(height: 6,),

                const Divider(color: Colors.grey,),

                Row(
                  children: [
                    const Expanded(child: Text("25 Aug 2022 @ 10:34am",
                        style: TextStyle(fontSize: 14,color: textColorLight))),

                    Row(
                      children: [
                        Icon(Icons.remove_red_eye,
                            size: 17,color: primaryColor),
                        const SizedBox(width: 8,),
                        Text("19 views",
                            style: TextStyle(fontSize: 14,color: textColorLight)),
                        const SizedBox(width: 24,),

                        Icon(Icons.comment_outlined,
                        size: 17,color: primaryColor,),
                        const SizedBox(width: 8,),
                        Text("19 comments",
                        style: TextStyle(fontSize: 14,color: textColorLight),),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 12,),



                Row(
                  children: const [
                  Text("Last Edited: 12 Sep 2022 @ 7:30pm",
                  style: TextStyle(fontSize: 14),)
                  ],
                ),

                const SizedBox(height: 6,),

                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>
                      NewPostPage()));
                    }, icon: const Icon(Icons.edit,
                    size: 18,
                    color: textColorPrimary,)),
                    IconButton(onPressed: (){
                      displayCustomCupertinoDialog(context: context,
                          title: "Delete Post?", msg: "Are you sure you want to delete this post?",
                          actionsMap: {"Yes":(){Navigator.pop(context);},"No":(){Navigator.pop(context);}},);
                    }, icon: Icon(CupertinoIcons.delete,
                      size: 18,
                      color: textColorPrimary,))
                  ],
                ),

                const SizedBox(height: 12,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


const String loremIpsum=
    "Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for "
    "the video that best fits your document. To make your document look "
    "professionally produced, Word provides header, footer, cover page and text box "
    "designs that complement each other. For example, you can add a matching cover page, header and sidebar.";