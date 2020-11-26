
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool markAdded);

//test http://img1.doubanio.com/view/photo/s_ratio_poster/public/p457760035.webp
///点击图片变成订阅状态的缓存图片控件;;;
class SubjectMarkImageWidget extends StatefulWidget {
  final imgNetUrl;
  final BoolCallback markAddCallBack;
  var height;
  final width;

  /// 这样做事为了传值， 也可以可以使用 InheritedWidget 提供中间类，记录值，传递
  /// 跨组件传递数据的三种方式   https://blog.csdn.net/yxw_android/article/details/101423819   https://blog.csdn.net/ITxiaodong/article/details/105083180
  /// 1. InheritedWidget （依赖父子widget, 父 -> 子）
  /// 2. notification  依赖父子widget, 子 -> 父）
  /// 3. EventBus   🙅不依赖父子widget 实现跨组件传值
  SubjectMarkImageWidget(this.imgNetUrl, {Key key, this.markAddCallBack, this.width = 150, this.height}) : super(key: key);

  @override
  _SubjectMarkImageWidgetState createState() {
    if (this.height == null) {
      this.height = this.width / 150 * 210;
    }
    return _SubjectMarkImageWidgetState(imgNetUrl, markAddCallBack, width, this.height);
  }
}

class _SubjectMarkImageWidgetState extends State<SubjectMarkImageWidget>  {

  var isMarkAdd = false;
  String imgLocalPath, imgNetUrl;
  final BoolCallback markAddCallback;
  var markAddedIcon, defaultMarkIcon;
  var loadImg;
  var imgWH = 28.0;
  var height, width;

  _SubjectMarkImageWidgetState(this.imgNetUrl, this.markAddCallback, this.width, this.height);

  @override
  void initState() {
    super.initState();
    markAddedIcon = Image(image: AssetImage(Constant.ASSETS_IMG + 'ic_subject_mark_added.png'), width: imgWH, height: imgWH);
    defaultMarkIcon = ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
      child: Image(image: AssetImage(Constant.ASSETS_IMG + 'ic_subject_rating_mark_wish.png'), width: imgWH, height: imgWH),
    );
    var defaultImg = Image.asset(Constant.ASSETS_IMG + 'ic_default_img_subject_movie.9.png');

    loadImg = ClipRRect(
      child: CachedNetworkImage(
        imageUrl: imgNetUrl,
        width: width,
        height: height,
        fit: BoxFit.fill,
        /// 占位图
        placeholder: (BuildContext context, String url){

          return defaultImg;
        },
        fadeInDuration: const Duration(milliseconds: 80),
        fadeOutDuration: const Duration(milliseconds: 80),
      ),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 底部的网络电影海报图
        loadImg,
        // 左上角的订阅图标
        GestureDetector(
          child: isMarkAdd ? markAddedIcon : defaultMarkIcon,
          onTap: () {
            if (markAddCallback != null) {
              markAddCallback(isMarkAdd);
            }
            setState(() {
              isMarkAdd = !isMarkAdd;
            });
          },
        ),
      ],
    );
  }
}
