import 'package:doubanapp/bean/subject_entity.dart';
import 'package:flutter/material.dart';


class HotSoonTabbar extends StatefulWidget {
  @override
  _HotSoonTabbarState createState() => _HotSoonTabbarState();

  void setCount(List<Subject> hotShowBeans) {

  }

  void setComingSoon(List<Subject> comingSoonBeans) {

  }
}

class _HotSoonTabbarState extends State<HotSoonTabbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
