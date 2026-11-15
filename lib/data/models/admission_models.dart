class StudentResponse {
  final bool success;
  final List<String> errors;
  final StudentData? data;
  final String versionMobile;

  StudentResponse({
    required this.success,
    required this.errors,
    this.data,
    required this.versionMobile,
  });

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      success: json['success'] ?? false,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      data: json['data'] != null ? StudentData.fromJson(json['data']) : null,
      versionMobile: json['versionMobile']?.toString() ?? '',
    );
  }
}

class StudentData {
  final String? resumeToken;
  final BasicInfo? basic;

  StudentData({this.resumeToken, this.basic});

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      resumeToken: json['resume_token'],
      basic: json['basic'] != null ? BasicInfo.fromJson(json['basic']) : null,
    );
  }
}

class BasicInfo {
  final String name;
  final String nationality;
  final String idCard;
  final String passport;
  final String phone;
  final String gender;

  BasicInfo({
    required this.name,
    required this.nationality,
    required this.idCard,
    required this.passport,
    required this.phone,
    required this.gender,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      name: json['name'] ?? '',
      nationality: json['nationality'] ?? '',
      idCard: json['ID_card'] ?? '',
      passport: json['passport'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}

class OptionsResponse {
  final bool success;
  final List<String> errors;
  final OptionsData data;
  final String versionMobile;

  OptionsResponse({
    required this.success,
    required this.errors,
    required this.data,
    required this.versionMobile,
  });

  factory OptionsResponse.fromJson(Map<String, dynamic> json) {
    return OptionsResponse(
      success: json['success'] ?? false,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      data: OptionsData.fromJson(json['data'] ?? {}),
      versionMobile: json['versionMobile']?.toString() ?? '',
    );
  }
}

class OptionsData {
  final List<OptionItem> nationalities;
  final List<OptionItem> religions;
  final List<OptionItem> governorates;
  final List<OptionItem> qualifications;
  final List<OptionItem> academicYears;

  OptionsData({
    required this.nationalities,
    required this.religions,
    required this.governorates,
    required this.qualifications,
    required this.academicYears,
  });

  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(
      nationalities: (json['nationalities'] as List<dynamic>?)
              ?.map((e) => OptionItem.fromJson(e))
              .toList() ??
          [],
      religions: (json['religions'] as List<dynamic>?)
              ?.map((e) => OptionItem.fromJson(e))
              .toList() ??
          [],
      governorates: (json['governorates'] as List<dynamic>?)
              ?.map((e) => OptionItem.fromJson(e))
              .toList() ??
          [],
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((e) => OptionItem.fromJson(e))
              .toList() ??
          [],
      academicYears: (json['academic_years'] as List<dynamic>?)
              ?.map((e) => OptionItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OptionItem {
  final int pk;
  final String name;

  OptionItem({required this.pk, required this.name});

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      pk: json['pk'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
