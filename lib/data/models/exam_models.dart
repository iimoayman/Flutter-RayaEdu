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

  ExamInfo({
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

  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      sectionNumber: json['section_number'],
      termName: json['student_term__term__name'] ?? '',
      academicYear: json['student_term__term__academic_year__name'] ?? '',
      materialName: json['open_material__material_skill__material__name'] ?? '',
      roomName: json['student_committee__student_examination_committee__examination_committee__location_committee__room__name'] ?? '',
      committeeNumber: json['student_committee__student_examination_committee__examination_committee__location_committee__committee_number'] ?? 0,
      locationNumber: json['student_committee__student_examination_committee__location_number'] ?? 0,
      groupExam: json['student_term__student_academic_year__student_regulation__admission_data__student__admission_data__group_exam'] ?? '',
      time: json['student_committee__student_examination_committee__examination_committee__material_committee__time_committee'] ?? '',
    );
  }
}

class ExamResultDto {
  final double maxDegree;
  final int questionExam;
  final String materialName;
  final String academicYear;
  final String termName;
  final String termDisplay;
  final double totalDegree;

  ExamResultDto({
    required this.maxDegree,
    required this.questionExam,
    required this.materialName,
    required this.academicYear,
    required this.termName,
    required this.termDisplay,
    required this.totalDegree,
  });

  factory ExamResultDto.fromJson(Map<String, dynamic> json) {
    return ExamResultDto(
      maxDegree: (json['max_degree'] as num?)?.toDouble() ?? 0.0,
      questionExam: json['question__exam'] ?? 0,
      materialName: json['question__exam__open_material__material_skill__material__name'] ?? '',
      academicYear: json['question__exam__open_material__material_table__academic_term__academic_year__name'] ?? '',
      termName: json['question__exam__open_material__material_table__academic_term__name'] ?? '',
      termDisplay: json['term_display'] ?? '',
      totalDegree: (json['total_degree'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ResultsResponse {
  final String typeResponse;
  final List<ResultItem> resultsData;

  ResultsResponse({
    required this.typeResponse,
    required this.resultsData,
  });

  factory ResultsResponse.fromJson(Map<String, dynamic> json) {
    return ResultsResponse(
      typeResponse: json['typeResponse'] ?? '',
      resultsData: (json['resultsData'] as List<dynamic>?)
              ?.map((e) => ResultItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ResultItem {
  final String evaluation;
  final String termName;
  final double cgpa;
  final String academicYearName;
  final String statusAlert;
  final String materialName;
  final String? notes;

  ResultItem({
    required this.evaluation,
    required this.termName,
    required this.cgpa,
    required this.academicYearName,
    required this.statusAlert,
    required this.materialName,
    this.notes,
  });

  factory ResultItem.fromJson(Map<String, dynamic> json) {
    return ResultItem(
      evaluation: json['evaluation'] ?? '',
      termName: json['student_material__student_term__term__name'] ?? '',
      cgpa: (json['student_material__student_term__cgpa'] as num?)?.toDouble() ?? 0.0,
      academicYearName: json['student_material__student_term__term__academic_year__name'] ?? '',
      statusAlert: json['student_material__student_term__status_alert'] ?? '',
      materialName: json['student_material__open_material__material_skill__material__name'] ?? '',
      notes: json['notes'],
    );
  }
}
