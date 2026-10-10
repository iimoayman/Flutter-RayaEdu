import 'MaterialREsponse.dart';

class StudyMaterials {
  final double attendanceRate;
  final String materialName;
  final String materialImg;
  final String profName;
  final int materialPk;
  final List<SessionsOnlineRy>? onlinelectures;

  const StudyMaterials({
    required this.attendanceRate,
    required this.materialName,
    required this.materialImg,
    required this.profName,
    required this.materialPk,
    this.onlinelectures,
  });

  factory StudyMaterials.fromJson(Map<String, dynamic> j) => StudyMaterials(
    attendanceRate:
    (j['attendanceRate'] as num?)?.toDouble() ?? 0.0,
    materialName: j[
    'open_material__material_table__profesor_material__material__name']
    as String? ??
        '',
    materialImg: j[
    'open_material__material_table__profesor_material__material__photo']
    as String? ??
        '',
    profName: j[
    'open_material__material_table__profesor_material__profesor__name']
    as String? ??
        '',
    materialPk: (j[
    'open_material__material_table__profesor_material__pk']
    as num?)
        ?.toInt() ??
        0,
    onlinelectures: (j['onlinelectures'] as List?)
        ?.map((e) => SessionsOnlineRy.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}