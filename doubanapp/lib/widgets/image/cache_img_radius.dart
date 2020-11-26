
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnTap = void Function();

class CacheImgRadius extends StatelessWidget {

  final String imgUrl;
  final double radius;
  final OnTap ontap;

  CacheImgRadius({Key key, @required this.imgUrl, this.radius, this.ontap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// 剪圆角， 给子控件的剪圆角
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(imageUrl: imgUrl),
      ),
      onTap: () {
        ontap();
      },
    );
  }
}
