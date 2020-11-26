
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doubanapp/bean/movie_top_item_bean.dart';
import 'package:doubanapp/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TopItemWidget extends StatelessWidget {

  // 标题
  String title;
  // 电影排行类型模型
  MovieTopItemBean bean;

  final Color partColor;

  TopItemWidget({Key key, this.title, this.bean, this.partColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bean == null) {
      return Container();
    }

    double _imgSize = MediaQuery.of(context).size.width / 5 * 3;
    return Container(
      width: _imgSize,
      height: _imgSize,
      padding: EdgeInsets.only(top:2, right: 10),
      // color: ColorConstant.randomColor(),
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(5.0) ,
              child: CachedNetworkImage(
                imageUrl: bean.imgUrl,
                fit: BoxFit.cover,
                width: _imgSize,
                height: _imgSize,
              ),
          ),
          Positioned(
            top: 8,
            right: 15,
            child: Text(
              bean.count,
              style: TextStyle(
                fontSize: 12,
                color:
                Colors.white,
                shadows:[  /// 文字 阴影
                  Shadow(color: Colors.black, offset: Offset(1, 2), blurRadius: 4)
                ],),),
          ),
          Positioned(
            top: _imgSize / 2 - 40,
            left: 30,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 21.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: _imgSize / 2 - 2,
            /// 高斯模糊，背景模糊, 这里使用了裁剪， 为了让指定的区域才有模糊效果
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
              child: BackdropFilter(
                filter:  ui.ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    width: _imgSize - 10,
                    height: _imgSize / 2,
                    decoration: BoxDecoration(
                        color: partColor,
                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
