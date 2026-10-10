
part of 'exam_result_dto.dart';

ExamResultDto _$ExamResultDtoFromJson(Map<String, dynamic> json) =>
    ExamResultDto(
      maxDegree: (json['max_degree'] as num).toDouble(),
      questionExam: (json['question__exam'] as num).toInt(),
      materialName: json[
      'question__exam__open_material__material_skill__material__name'] as String,
      academicYear: json[
      'question__exam__open_material__material_table__academic_term__academic_year__name']
      as String,
      termName: json[
      'question__exam__open_material__material_table__academic_term__name']
      as String,
      termDisplay: json['term_display'] as String,
      totalDegree: (json['total_degree'] as num).toDouble(),
    );

Map<String, dynamic> _$ExamResultDtoToJson(ExamResultDto instance) =>
    <String, dynamic>{
      'max_degree': instance.maxDegree,
      'question__exam': instance.questionExam,
      'question__exam__open_material__material_skill__material__name':
      instance.materialName,
      'question__exam__open_material__material_table__academic_term__academic_year__name':
      instance.academicYear,
      'question__exam__open_material__material_table__academic_term__name':
      instance.termName,
      'term_display': instance.termDisplay,
      'total_degree': instance.totalDegree,
    };