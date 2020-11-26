
import 'package:doubanapp/constant/color_constant.dart';
import 'package:doubanapp/constant/text_size_constant.dart';
import 'package:flutter/material.dart';

typedef OnTap = void Function();

class ItemCountTitle extends StatelessWidget {
  final int count;
  final OnTap onTap;
  final String title;
  final double fontSize;

  ItemCountTitle(this.title, {Key key, this.onTap, this.count, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
         Expanded(
           child:  Text(title,
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: fontSize == null ? TextSizeConstant.BookAudioPartTabBar : fontSize,
                 color: ColorConstant.colorDefaultTitle,
               )),
         ),
          Text('全部 ${count == null ? 0 : count} > ',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }
}
