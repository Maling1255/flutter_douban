
import 'package:flutter/material.dart';

class HeartImgWidget extends StatefulWidget {
  final Image img;
  HeartImgWidget(this.img, {Key key}) : super(key: key);

  @override
  _HeartImgWidgetState createState() => _HeartImgWidgetState();
}

class _HeartImgWidgetState extends State<HeartImgWidget> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: 1000), vsync:this);
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
          controller.reverse();
      } else {
        controller.forward();
      }
    });

    // 开始动画
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _AnimationImg(widget.img, animation: animation);
  }
}



/// 动画
class _AnimationImg extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.5, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 200, end: 300);
  final Image img;
  _AnimationImg(this.img, {Key key, Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    // 这里的listenable 是读取前面监听状态变化的animation,,,  addStatusListener
    final Animation<double> animation = listenable;

    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          // 竖直方向两头的间距设置 10
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: img,
          height: _sizeTween.evaluate(animation),
          width: _sizeTween.evaluate(animation),
          ),
      ),
    );
  }
}

