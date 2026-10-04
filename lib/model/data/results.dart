
class ResultsResponse {
  final String typeResponse;
  final List<ResultItem> resultsData;

  const ResultsResponse({
    required this.typeResponse,
    required this.resultsData,
  });

  factory ResultsResponse.fromJson(Map<String, dynamic> json) =>
      ResultsResponse(
        typeResponse: json['typeResponse'] as String? ?? '',
        resultsData: (json['resultsData'] as List<dynamic>? ?? [])
            .map((e) => ResultItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'typeResponse': typeResponse,
    'resultsData': resultsData.map((e) => e.toJson()).toList(),
  };
}

class ResultItem {
  final String evaluation;
  final String termName;
  final double cgpa;
  final String academicYearName;
  final String statusAlert;
  final String materialName;
  final String? notes;

  const ResultItem({
    required this.evaluation,
    required this.termName,
    required this.cgpa,
    required this.academicYearName,
    required this.statusAlert,
    required this.materialName,
    this.notes,
  });

  factory ResultItem.fromJson(Map<String, dynamic> json) => ResultItem(
    evaluation: json['evaluation'] as String? ?? '',
    termName:
    json['student_material__student_term__term__name'] as String? ?? '',
    cgpa:
    (json['student_material__student_term__cgpa'] as num?)?.toDouble() ??
        0.0,
    academicYearName: json[
    'student_material__student_term__term__academic_year__name']
    as String? ??
        '',
    statusAlert:
    json['student_material__student_term__status_alert'] as String? ??
        '',
    materialName: json[
    'student_material__open_material__material_skill__material__name']
    as String? ??
        '',
    notes: json['notes'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'evaluation': evaluation,
    'student_material__student_term__term__name': termName,
    'student_material__student_term__cgpa': cgpa,
    'student_material__student_term__term__academic_year__name':
    academicYearName,
    'student_material__student_term__status_alert': statusAlert,
    'student_material__open_material__material_skill__material__name':
    materialName,
    'notes': notes,
  };
}