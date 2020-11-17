import 'package:cached_network_image/cached_network_image.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///http://vt1.doubanio.com/201902111139/0c06a85c600b915d8c9cbdbbaf06ba9f/view/movie/M/302420330.mp4
class VideoWidget extends StatefulWidget {

  final String url;
  final String previewImgUrl;   // 预览图的地址
  final bool isShowProgressBar;  // 是否显示进度条
  final bool isShowProgressText; // 是否显示进度文本
  // 构造函数
  VideoWidget(this.url, {Key key, this.previewImgUrl, this.isShowProgressBar = true, this.isShowProgressText = true}) : super(key: key);

  _VideoWidgetState state;

  @override
  State<StatefulWidget> createState() {
    state = _VideoWidgetState();
    return state;
  }

  // 更新url
  updateUrl(String url) {
    state.setUrl(url);
  }
}

class _VideoWidgetState extends State<VideoWidget> {

  VideoPlayerController _controller;
  VoidCallback listener;
  // 是否显示进度指示条的bar
  bool _isShowSeekBar = true;

  // 初始化_VideoWidgetState调用；；；；；； 即  state = _VideoWidgetState(); 执行调用
  _VideoWidgetState() {
    listener = (){
      /// mounted 是 bool 类型，表示当前 State 是否加载到树⾥。
      /// 常用于判断页面是否释放。
      if (mounted) {
          setState(() {});
      }
    };
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
    ..initialize().then((_){
      if (mounted) {
          // 初始化完成，更新状态
        setState(() {});
        // 当前播放的位置 如果是视频时长的总长度，则跳到视频开始位置
        if (_controller.value.duration == _controller.value.position) {
          _controller.seekTo(Duration(seconds: 0));
          setState(() {});
        }
      }
    });
    ///注册一个在对象更改时被调用的闭包。
    ///
    ///在[dispose]被调用后不能调用此方法。
    _controller.addListener(listener);
  }

  /// deactivate:当State对象从树中被移除时，会调用此回调。
  /// dispose():当State对象从树中被永久移除时调用；通常在此回调中释放资源。
  /// 执行顺序， 先执行 deactivate -> dispose
  @override
  void deactivate() {
    _controller.removeListener(listener);
    super.deactivate();
  }

  FadeAnimation imageFadeAnimation;

  @override
  Widget build(BuildContext context) {

    final List<Widget> children = <Widget>[
      GestureDetector(
        child: VideoPlayer(_controller),
        onTap: () {
          setState(() {
            _isShowSeekBar = !_isShowSeekBar;
          });
        },
      ),
      getPlayerController(),
    ];

    /// AspectRatio 是固定宽高比的组件
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio, // 比率
      child: Stack(
        ///StackFit.loose：子组件宽松取值，可以从 min 到 max
        ///StackFit.expand：子组件取最大值
        ///StackFit.passthrough：不改变子组件约束条件
        /// passthrough
        /// 从父栈传递给堆栈的约束会原封不动地传递给未定位的子栈。
        /// 例如，如果一个[Stack]是一个[Row]的[展开的]子元素，那么水平约束将是紧密的，垂直约束将是松散的。
        fit: StackFit.passthrough,
        children: children,
      ),
    );
  }

  // 预览占位图
  Widget getPreviewImg() {
    return widget.previewImgUrl.isNotEmpty ? CachedNetworkImage(imageUrl: widget.previewImgUrl) : null;
  }

  // 进度条/进度文本/播放/暂停
  getPlayerController() {
    return Offstage(
      offstage: !_isShowSeekBar,
      child: Stack(
        children: <Widget>[
          Align(
            child: IconButton(
              iconSize: 55.0,
              icon: Image.asset(Constant.ASSETS_IMG + (_controller.value.isPlaying ? 'ic_pause.png' : 'ic_playing.png')),
              onPressed: () {
                if (_controller.value.isPlaying) {
                    _controller.pause();
                } else {
                  _controller.play();
                }
              }),
            alignment: Alignment.center,
          ),
          // 进度部分
          getProgressContent(),
          // 加载指示器部分，
          // LinearProgressIndicator 横向指示器
          // CircularProgressIndicator 圆圈⭕️指示器
          // CupertinoActivityIndicator 菊花指示器
          Align(
            alignment: Alignment.bottomCenter,
            child: _controller.value.isBuffering ? CircularProgressIndicator() : null,
          ),
        ],
      ),
    );
  }

  /// 更新播放URL
  void setUrl(String url) {
    if (!mounted) {
      return;
    }
    if (_controller != null) {
      _controller.removeListener(listener);
      _controller.pause();
    }
    _controller = VideoPlayerController.network(url)
    ..initialize().then((_) {
      // 初始化完成状态，更新状态
      setState(() {});
      if (_controller.value.duration == _controller.value.position) {
        _controller.seekTo(Duration(seconds: 0));
      }
      setState(() {});
    });
      _controller.addListener(listener);
  }

  // 进度内容
  Widget getProgressContent() {
    final isShowBar = (widget.isShowProgressBar || widget.isShowProgressText);
    return isShowBar
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                // progressbar 进度条
                Expanded(
                  child: Container(
                    height: 13.0,
                    margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Offstage(
                      offstage: !widget.isShowProgressBar,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(playedColor: Colors.amberAccent, backgroundColor: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // progress进度文本00：00
                Offstage(
                  child: _getDurationText(),
                  offstage: !widget.isShowProgressText,
                ),
              ],
            ),
          )
        : Constant();
  }

  _getDurationText() {
    var text;
    if (_controller.value.position == null || _controller.value.duration == null) {
        text = '00:00/00:00';
    } else {
        text = '${_getMinuteSeconds(_controller.value.position.inSeconds)}/${_getMinuteSeconds(_controller.value.duration.inSeconds)}';
    }
    return Text('$text', style: TextStyle(color: Colors.redAccent, fontSize: 14.0));
  }

  // 转时间, 格式化时间
  _getMinuteSeconds(var inSeconds) {
    if (inSeconds == null || inSeconds <= 0) {
        return '00:00';
    }

    /// ~/ 代表整除   / 代表除的结果是小数
    var tmp = inSeconds ~/ Duration.secondsPerMinute;
    var minute;
    if (tmp < 10) {
      minute = '0$tmp';
    } else {
      minute = '$tmp';
    }

    var tmp1 = inSeconds % Duration.secondsPerMinute;
    var seconds;
    if (tmp1 < 10) {
      seconds = '0$tmp1';
    } else {
      seconds = '$tmp1';
    }

    return '$minute:$seconds';
  }
}


/// --------------------------------------------------------------------------  视频播放player
class VideoPlayer extends StatefulWidget {

  final VideoPlayerController controller;
  VideoPlayer(this.controller);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  VoidCallback _listener;
  // 纹理值
  int _textureId;

  _VideoPlayerState() {
    _listener = () {
      final int newTextured = widget.controller.textureId;
      if (newTextured != _textureId) {
          setState(() {
            _textureId = newTextured;
          });
      }
    };
  }

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
    widget.controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    _textureId = widget.controller.textureId;
    // 重新监听
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.controller.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {

    return _textureId == null ? Container() : Texture(textureId: _textureId);
  }
}



/// --------------------------------------------------------------------------  渐隐渐现动画
class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeAnimation({this.child, this.duration = const Duration(milliseconds: 1500)});

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> with SingleTickerProviderStateMixin {

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
          setState(() {});
      }
    });
    // 将动画设置到到动画开始位置
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
        animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating ? Opacity(opacity: 1.0 - animationController.value, child: widget.child,) : Container();
  }
}
