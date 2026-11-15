class StudentProfileEntity {
  final String name;
  final String photoUrl;
  final String academicYear;
  final int? code;
  final String departmentName;
  final String levelName;
  final double? hours;
  final double? cgpa;
  final String guideName;
  final String? whatsapp;

  StudentProfileEntity({
    required this.name,
    required this.photoUrl,
    required this.academicYear,
    this.code,
    required this.departmentName,
    required this.levelName,
    this.hours,
    this.cgpa,
    required this.guideName,
    this.whatsapp,
  });
}
