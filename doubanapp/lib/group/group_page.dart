
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/request/API.dart';
import 'package:doubanapp/request/http_request.dart';
import 'package:doubanapp/request/simulate_request.dart';
import 'package:doubanapp/widgets/image/radius_img.dart';
import 'package:doubanapp/widgets/part/loading_widget.dart';
import 'package:doubanapp/widgets/part/search_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class GroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String hintText = '搜索书影音，小组, 日记，用户等';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SearchTextFieldWidget(
              margin: EdgeInsets.all(Constant.MARGIN_RIGHT),
              hintText: hintText,
              onTap: () {
                Logger().i('小组 - 搜索');
              },
            ),
            Expanded(
                child: GroupWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupWidget extends StatefulWidget {
  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

// var _request = HttpRequest(API.BASE_URL);

var _request = SimulateRequest();

class _GroupWidgetState extends State<GroupWidget> {

  List<Subject> list;
  // 是否正在加载
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future(() {
      // 这里使用的模拟数据
      return  _request.get(API.IN_THEATERS);
    }).then((result) {
      var resultList = result['subjects'];

      setState(() {
        /// 拿到模型数组
        list = resultList.map<Subject>((info) => Subject.fromMap(info)).toList();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget.ContainerLoadingBody(getBoday(), isloading: isLoading);
  }

  Widget getBoday() {
    if (list == null) {
        return Container(child: Image.asset(Constant.ASSETS_IMG + 'ic_group_top.png'));
    }

    /// 列表
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _getItem(list[index], index);
      },
      itemCount: 10,
    );

  }

  Widget _getItem(Subject bean, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: <Widget>[
          RadiusImg.get(bean.images.small, 50.0, radius: 3.0),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    bean.title,
                    style:
                    TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  Text(bean.pubdates != null ? bean.pubdates[0] : '', style: TextStyle(fontSize: 13.0))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text('${bean.collect_count}人', style: TextStyle(fontSize: 13.0),),
          ),
          GestureDetector(
            child: Image.asset(
              Constant.ASSETS_IMG +
                  (list[index].tag
                      ? 'ic_group_checked_anonymous.png'
                      : 'ic_group_check_anonymous.png'),
              width: 25.0,
              height: 25.0,
            ),
            onTap: () {
              setState(() {
                list[index].tag = !list[index].tag;
              });
            },
          )
        ],
      ),
    );
  }

}

