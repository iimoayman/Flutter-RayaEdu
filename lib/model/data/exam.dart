
class ExamInfo {
  final int? sectionNumber;
  final String termName;
  final String academicYear;
  final String materialName;
  final String roomName;
  final int committeeNumber;
  final int locationNumber;
  final String groupExam;
  final String time;

  const ExamInfo({
    this.sectionNumber,
    required this.termName,
    required this.academicYear,
    required this.materialName,
    required this.roomName,
    required this.committeeNumber,
    required this.locationNumber,
    required this.groupExam,
    required this.time,
  });

  factory ExamInfo.fromJson(Map<String, dynamic> json) => ExamInfo(
    sectionNumber: json['section_number'] as int?,
    termName: json['student_term__term__name'] as String? ?? '',
    academicYear:
    json['student_term__term__academic_year__name'] as String? ?? '',
    materialName:
    json['open_material__material_skill__material__name'] as String? ??
        '',
    roomName: json[
    'student_committee__student_examination_committee__examination_committee__location_committee__room__name']
    as String? ??
        '',
    committeeNumber: json[
    'student_committee__student_examination_committee__examination_committee__location_committee__committee_number']
    as int? ??
        0,
    locationNumber: json[
    'student_committee__student_examination_committee__location_number']
    as int? ??
        0,
    groupExam: json[
    'student_term__student_academic_year__student_regulation__admission_data__student__admission_data__group_exam']
    as String? ??
        '',
    time: json[
    'student_committee__student_examination_committee__examination_committee__material_committee__time_committee']
    as String? ??
        '',
  );

  Map<String, dynamic> toJson() => {
    'section_number': sectionNumber,
    'student_term__term__name': termName,
    'student_term__term__academic_year__name': academicYear,
    'open_material__material_skill__material__name': materialName,
    'student_committee__student_examination_committee__examination_committee__location_committee__room__name':
    roomName,
    'student_committee__student_examination_committee__examination_committee__location_committee__committee_number':
    committeeNumber,
    'student_committee__student_examination_committee__location_number':
    locationNumber,
    'student_term__student_academic_year__student_regulation__admission_data__student__admission_data__group_exam':
    groupExam,
    'student_committee__student_examination_committee__examination_committee__material_committee__time_committee':
    time,
  };
}