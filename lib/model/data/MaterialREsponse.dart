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

  factory MaterialResponse.fromJson(Map<String, dynamic> j) => MaterialResponse(
    materialName: j[
    'open_material_material_tableprofesor_materialmaterial_name']
    as String?,
    materialPhoto: j[
    'open_material_material_tableprofesor_materialmaterial_photo']
    as String?,
    professorName: j[
    'open_material_material_tableprofesor_materialprofesor_name']
    as String?,
    startTime: j['start_time'] as String?,
    url: j['url'] as String?,
  );
}

/// Mirrors `SessionsOnlineRy`
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

  factory SessionsOnlineRy.fromJson(Map<String, dynamic> j) => SessionsOnlineRy(
    materialName: j[
    'open_material_material_tableprofesor_materialmaterial_name']
    as String?,
    materialPhoto: j[
    'open_material_material_tableprofesor_materialmaterial_photo']
    as String?,
    professorName: j[
    'open_material_material_tableprofesor_materialprofesor_name']
    as String?,
    startTime: j['start_time'] as String?,
    url: j['url'] as String? ?? '',
  );
}