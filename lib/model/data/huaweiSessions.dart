class HuaweiSession {
  final String link;
  final String title;
  final String instructor;
  final String time;

  const HuaweiSession({
    this.link = ' ',
    this.title = ' ',
    this.instructor = ' ',
    this.time = ' ',
  });

  factory HuaweiSession.fromJson(Map<String, dynamic> j) => HuaweiSession(
    link: j['link'] as String? ?? ' ',
    title: j['title'] as String? ?? ' ',
    instructor: j['instructor'] as String? ?? ' ',
    time: j['Time'] as String? ?? j['time'] as String? ?? ' ',
  );
}