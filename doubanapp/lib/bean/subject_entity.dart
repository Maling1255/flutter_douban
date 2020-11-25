class SubjectEntity {

  Subject subject;
  // 排名
  var rank;
  // 热度的正负值， 如果为正 热度上升， 如果为负 热度下降
  var delta;

  /// 命名构造函数
  SubjectEntity.fromMap(Map<String, dynamic> map) {
    rank = map['rank'];
    delta = map['delta'];
    var subjectMap = map['subject'];
    subject = Subject.fromMap(subjectMap);
  }
}


class Subject {
  bool tag = false;
  Rating rating;
  var genres;
  var title;
  List<Cast> casts;
  var durations;
  var collect_count;
  var mainland_pubdate;
  var has_video;
  var original_title;
  var subtype;
  var directors;
  var pubdates;
  var year;
  Images images;
  var alt;
  var id;


  /// map 转 模型
  Subject.fromMap(Map<String, dynamic> map) {
    var rating = map['rating'];
    this.rating = Rating(rating['average'], rating['max']);
    genres = map['genres'];
    title = map['title'];
    var castMap = map['casts'];
    casts = _converCasts(castMap);
    collect_count = map['collect_count'];
    original_title = map['original_title'];
    subtype = map['subtype'];
    directors = map['directors'];
    year = map['year'];
    var img = map['images'];
    images = Images(img['small'], img['large'], img['medium']);
    alt = map['alt'];
    id = map['id'];
    durations = map['durations'];
    mainland_pubdate = map['mainland_pubdate'];
    has_video = map['has_video'];
    pubdates = map['pubdates'];
  }

  _converCasts(casts) {
    return casts.map<Cast>((item)=>Cast.fromMap(item)).toList();
  }

}

class Images {
  var small;
  var large;
  var medium;

  Images(this.small, this.large, this.medium);
}

/// 评分 星星
class Rating {
  var average;  // 平均值 double
  var max;
  Rating(this.average, this.max);
}


class Cast {
  var id;
  var name_en;
  var name;
  Avatar avatars;
  var alt;
  Cast(this.avatars, this.name_en, this.name, this.alt, this.id);

  Cast.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name_en = map['name_en'];
    name = map['name'];
    alt = map['alt'];
    var tmp = map['avatars'];
    if(tmp == null){
      avatars = null;
    }else{
      avatars = Avatar(tmp['small'], tmp['large'], tmp['medium']);
    }

  }
}

// 图的规格
class Avatar {
  var medium;  // 中
  var large;   // 大
  var small;   // 小
  Avatar(this.small, this.large, this.medium);
}
