
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

  factory StudyMaterials.fromJson(Map<String, dynamic> json) => StudyMaterials(
    attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0.0,
    materialName: json[
    'open_material__material_table__profesor_material__material__name']
    as String? ??
        '',
    materialImg: json[
    'open_material__material_table__profesor_material__material__photo']
    as String? ??
        '',
    profName: json[
    'open_material__material_table__profesor_material__profesor__name']
    as String? ??
        '',
    materialPk: json[
    'open_material__material_table__profesor_material__pk']
    as int? ??
        0,
    onlinelectures: (json['onlinelectures'] as List<dynamic>?)
        ?.map((e) => SessionsOnlineRy.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'attendanceRate': attendanceRate,
    'open_material__material_table__profesor_material__material__name':
    materialName,
    'open_material__material_table__profesor_material__material__photo':
    materialImg,
    'open_material__material_table__profesor_material__profesor__name':
    profName,
    'open_material__material_table__profesor_material__pk': materialPk,
    'onlinelectures': onlinelectures?.map((e) => e.toJson()).toList(),
  };
}

// ---------------------------------------------------------

class MaterialResponse {
  final String? materialName;
  final String? materialPhoto;
  final String? professorName;
  final String? startTime;
  final String? url;

  const MaterialResponse({
    this.materialName,
    this.materialPhoto,
    this.professorName,
    this.startTime,
    this.url,
  });

  factory MaterialResponse.fromJson(Map<String, dynamic> json) =>
      MaterialResponse(
        materialName:
        json['open_material_material_tableprofesor_materialmaterial_name']
        as String?,
        materialPhoto:
        json['open_material_material_tableprofesor_materialmaterial_photo']
        as String?,
        professorName:
        json['open_material_material_tableprofesor_materialprofesor_name']
        as String?,
        startTime: json['start_time'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'open_material_material_tableprofesor_materialmaterial_name':
    materialName,
    'open_material_material_tableprofesor_materialmaterial_photo':
    materialPhoto,
    'open_material_material_tableprofesor_materialprofesor_name':
    professorName,
    'start_time': startTime,
    'url': url,
  };
}

// ---------------------------------------------------------

class SessionsOnlineRy {
  final String? materialName;
  final String? materialPhoto;
  final String? professorName;
  final String? startTime;
  final String url;

  const SessionsOnlineRy({
    this.materialName,
    this.materialPhoto,
    this.professorName,
    this.startTime,
    required this.url,
  });

  factory SessionsOnlineRy.fromJson(Map<String, dynamic> json) =>
      SessionsOnlineRy(
        materialName:
        json['open_material_material_tableprofesor_materialmaterial_name']
        as String?,
        materialPhoto:
        json['open_material_material_tableprofesor_materialmaterial_photo']
        as String?,
        professorName:
        json['open_material_material_tableprofesor_materialprofesor_name']
        as String?,
        startTime: json['start_time'] as String?,
        url: json['url'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'open_material_material_tableprofesor_materialmaterial_name':
    materialName,
    'open_material_material_tableprofesor_materialmaterial_photo':
    materialPhoto,
    'open_material_material_tableprofesor_materialprofesor_name':
    professorName,
    'start_time': startTime,
    'url': url,
  };
}