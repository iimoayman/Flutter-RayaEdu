class Order {
  final String img;
  final String link;
  final int id;

  const Order({
    this.img = '',
    this.link = '',
    this.id = 0,
  });

  factory Order.fromJson(Map<String, dynamic> j) => Order(
    img: j['img'] as String? ?? '',
    link: j['link'] as String? ?? '',
    id: (j['id'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {'img': img, 'link': link, 'id': id};
}