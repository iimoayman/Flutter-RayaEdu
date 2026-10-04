class MyData {
  final String name;
  final String photoUrl;
  final String academicYear;
  final int? code;
  final String department;
  final String level;
  final double? hours;
  final double? cgpa;
  final String guideName;
  final String? whatsapp;

  const MyData({
    required this.name,
    required this.photoUrl,
    required this.academicYear,
    required this.code,
    required this.department,
    required this.level,
    required this.hours,
    required this.cgpa,
    required this.guideName,
    required this.whatsapp,
  });

  factory MyData.fromJson(Map<String, dynamic> json) => MyData(
    name: json['name']?.toString() ?? '',
    photoUrl: json['photo_url']?.toString() ?? '',
    academicYear: json['academic_year']?.toString() ?? '',
    code: json['code'] is int ? json['code'] as int : int.tryParse('${json['code']}'),
    department: json['department']?.toString() ?? '',
    level: json['level']?.toString() ?? '',
    hours: json['hours'] is num ? (json['hours'] as num).toDouble() : null,
    cgpa: json['cgpa'] is num ? (json['cgpa'] as num).toDouble() : null,
    guideName: json['guide_name']?.toString() ?? '',
    whatsapp: json['whatapp']?.toString(),
  );
}