import 'package:json_annotation/json_annotation.dart';

part 'exam_result_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExamResultDto {
  @JsonKey(name: 'max_degree')
  final double maxDegree;

  @JsonKey(name: 'question__exam')
  final int questionExam;

  @JsonKey(name: 'question__exam__open_material__material_skill__material__name')
  final String materialName;

  @JsonKey(name: 'question__exam__open_material__material_table__academic_term__academic_year__name')
  final String academicYear;

  @JsonKey(name: 'question__exam__open_material__material_table__academic_term__name')
  final String termName;

  @JsonKey(name: 'term_display')
  final String termDisplay;

  @JsonKey(name: 'total_degree')
  final double totalDegree;

  const ExamResultDto({
    required this.maxDegree,
    required this.questionExam,
    required this.materialName,
    required this.academicYear,
    required this.termName,
    required this.termDisplay,
    required this.totalDegree,
  });

  factory ExamResultDto.fromJson(Map<String, dynamic> json) =>
      _$ExamResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExamResultDtoToJson(this);
}