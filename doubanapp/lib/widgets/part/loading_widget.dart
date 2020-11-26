
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget {

  static Widget getLoading({Color backgroundColor, Color loadingBackgroundColor}) {
    return Container(
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: backgroundColor == null ? Colors.transparent : backgroundColor,
      ),
      child: Container(  // 背景框
        decoration: BoxDecoration(
          color: loadingBackgroundColor == null ? Colors.white : loadingBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          /// 设置阴影效果
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              blurRadius: 5.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        height: 70.0,
        width: 70.0,
        alignment: Alignment.center,
        child: SizedBox(  // 菊花
          /// 加载的菊花加载
          child: CupertinoActivityIndicator(radius: 15.0),
        ),
      ),
    );
  }

  // 包装一下 body & 加载框
  static Widget ContainerLoadingBody(Widget body, {bool isloading = true, Color backgroundColor, Color loadingBackgroundColor}) {
    return Stack(
      children: <Widget>[
        body,
        /// 隐藏widget  offstage: true 隐藏， false 显示
        Offstage(
          offstage: !isloading,
          child: getLoading(
            backgroundColor: backgroundColor,
            loadingBackgroundColor: loadingBackgroundColor,
          ),
        ),
      ],
    );
  }

}