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

  factory ExamInfo.fromJson(Map<String, dynamic> j) => ExamInfo(
    sectionNumber: (j['section_number'] as num?)?.toInt(),
    termName: j['student_term__term__name'] as String? ?? '',
    academicYear:
    j['student_term__term__academic_year__name'] as String? ?? '',
    materialName: j[
    'open_material__material_skill__material__name']
    as String? ??
        '',
    roomName: j[
    'student_committee__student_examination_committee__examination_committee__location_committee__room__name']
    as String? ??
        '',
    committeeNumber: (j[
    'student_committee__student_examination_committee__examination_committee__location_committee__committee_number']
    as num?)
        ?.toInt() ??
        0,
    locationNumber: (j[
    'student_committee__student_examination_committee__location_number']
    as num?)
        ?.toInt() ??
        0,
    groupExam: j[
    'student_term__student_academic_year__student_regulation__admission_data__student__admission_data__group_exam']
    as String? ??
        '',
    time: j[
    'student_committee__student_examination_committee__examination_committee__material_committee__time_committee']
    as String? ??
        '',
  );
}