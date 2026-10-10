import '../data/api_res.dart';
import '../data/order.dart';
import '../data/studentMaterials.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'supabase.dart';

class MaterialsService {
  Future<List<StudyMaterials>> fetch() async {
    await ApiClient.instance.init();

    final res = await ApiClient.instance.dio.get(
      ApiRoutes.app,
      queryParameters: {'main_target': MainTarget.platformMaterials},
    );

    final apiRes = ApiRes<List<StudyMaterials>>.fromJson(
      (res.data as Map).cast<String, dynamic>(),
          (data) => (data as List)
          .map((e) =>
          StudyMaterials.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

    return apiRes.data ?? [];
  }

  Future<List<StudyMaterials>> refreshMaterials() => fetch();

  Future<List<Order>> fetchBanners() => SupabaseService().fetchBanners();
}

/// Lightweight material model used by the portal list.
class Material {
  final int? pk;
  final String? name;
  final String? photo;
  final String? professorName;

  const Material({this.pk, this.name, this.photo, this.professorName});

  factory Material.fromJson(Map<String, dynamic> j) => Material(
    pk: (j['pk'] as num?)?.toInt(),
    name: j['name'] as String?,
    photo: j['photo'] as String?,
    professorName:
    j['profesor_name'] as String? ?? j['professor_name'] as String?,
  );
}