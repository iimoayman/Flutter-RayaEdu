class OptionItem {
  final int pk;
  final String name;

  const OptionItem({required this.pk, required this.name});

  factory OptionItem.fromJson(Map<String, dynamic> j) => OptionItem(
    pk: (j['pk'] as num?)?.toInt() ?? 0,
    name: j['name'] as String? ?? '',
  );
}

class OptionsData {
  final List<OptionItem> nationalities;
  final List<OptionItem> religions;
  final List<OptionItem> governorates;
  final List<OptionItem> qualifications;
  final List<OptionItem> academicYears;   // academic_years

  const OptionsData({
    required this.nationalities,
    required this.religions,
    required this.governorates,
    required this.qualifications,
    required this.academicYears,
  });

  factory OptionsData.fromJson(Map<String, dynamic> j) => OptionsData(
    nationalities: _list(j['nationalities']),
    religions: _list(j['religions']),
    governorates: _list(j['governorates']),
    qualifications: _list(j['qualifications']),
    academicYears: _list(j['academic_years']),
  );

  static List<OptionItem> _list(dynamic raw) =>
      (raw as List? ?? [])
          .map((e) => OptionItem.fromJson(e as Map<String, dynamic>))
          .toList();
}

/// Mirrors `OptionsResponse`
class OptionsResponse {
  final bool success;
  final List<String> errors;
  final OptionsData data;
  final String versionMobile;

  const OptionsResponse({
    required this.success,
    required this.errors,
    required this.data,
    required this.versionMobile,
  });

  factory OptionsResponse.fromJson(Map<String, dynamic> j) => OptionsResponse(
    success: j['success'] as bool? ?? false,
    errors:
    (j['errors'] as List? ?? []).map((e) => e.toString()).toList(),
    data: OptionsData.fromJson(j['data'] as Map<String, dynamic>),
    versionMobile: j['versionMobile'] as String? ?? '',
  );
}