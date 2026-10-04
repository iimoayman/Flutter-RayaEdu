
class Order {
  String img;
  String link;
  int id;

  Order({
    this.img = '',
    this.link = '',
    this.id = 0,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    img: json['img'] as String? ?? '',
    link: json['link'] as String? ?? '',
    id: (json['id'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'img': img,
    'link': link,
    'id': id,
  };
}

// ---------------------------------------------------------

class HuaweiSession {
  String link;
  String title;
  String instructor;
  String time;

  HuaweiSession({
    this.link = ' ',
    this.title = ' ',
    this.instructor = ' ',
    this.time = ' ',
  });

  factory HuaweiSession.fromJson(Map<String, dynamic> json) => HuaweiSession(
    link: json['link'] as String? ?? ' ',
    title: json['title'] as String? ?? ' ',
    instructor: json['instructor'] as String? ?? ' ',
    time: json['Time'] as String? ?? ' ',
  );

  Map<String, dynamic> toJson() => {
    'link': link,
    'title': title,
    'instructor': instructor,
    'Time': time,
  };
}