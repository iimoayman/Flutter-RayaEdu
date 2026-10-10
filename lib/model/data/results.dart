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
        resultsData: (json['resultsData'] as List? ?? [])
            .map((e) => ResultItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// Mirrors `ResultItem`
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

  factory ResultItem.fromJson(Map<String, dynamic> j) => ResultItem(
    evaluation: j['evaluation'] as String? ?? '',
    termName: j['student_material__student_term__term__name'] as String? ??
        '',
    cgpa:
    (j['student_material__student_term__cgpa'] as num?)?.toDouble() ??
        0.0,
    academicYearName:
    j['student_material__student_term__term__academic_year__name']
    as String? ??
        '',
    statusAlert:
    j['student_material__student_term__status_alert'] as String? ?? '',
    materialName: j[
    'student_material__open_material__material_skill__material__name']
    as String? ??
        '',
    notes: j['notes'] as String?,
  );
}