class StudyMaterials {
  final double attendanceRate;
  final String materialName;
  final String materialImg;
  final String profName;
  final int materialPk;
  final List<SessionsOnlineRy>? onlineLectures;

  StudyMaterials({
    required this.attendanceRate,
    required this.materialName,
    required this.materialImg,
    required this.profName,
    required this.materialPk,
    this.onlineLectures,
  });

  factory StudyMaterials.fromJson(Map<String, dynamic> json) {
    return StudyMaterials(
      attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0.0,
      materialName: json['open_material__material_table__profesor_material__material__name'] ?? '',
      materialImg: json['open_material__material_table__profesor_material__material__photo'] ?? '',
      profName: json['open_material__material_table__profesor_material__profesor__name'] ?? '',
      materialPk: json['open_material__material_table__profesor_material__pk'] ?? 0,
      onlineLectures: (json['onlinelectures'] as List<dynamic>?)
          ?.map((e) => SessionsOnlineRy.fromJson(e))
          .toList(),
    );
  }
}

class SessionsOnlineRy {
  final String? materialName;
  final String? materialPhoto;
  final String? professorName;
  final String? startTime;
  final String url;

  SessionsOnlineRy({
    this.materialName,
    this.materialPhoto,
    this.professorName,
    this.startTime,
    required this.url,
  });

  factory SessionsOnlineRy.fromJson(Map<String, dynamic> json) {
    return SessionsOnlineRy(
      materialName: json['open_material_material_tableprofesor_materialmaterial_name'],
      materialPhoto: json['open_material_material_tableprofesor_materialmaterial_photo'],
      professorName: json['open_material_material_tableprofesor_materialprofesor_name'],
      startTime: json['start_time'],
      url: json['url'] ?? '',
    );
  }
}

class MainPortal {
  final List<Chapter> chapters;
  final ChapterDetails chapterData;

  MainPortal({
    required this.chapters,
    required this.chapterData,
  });

  factory MainPortal.fromJson(Map<String, dynamic> json) {
    return MainPortal(
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e))
              .toList() ??
          [],
      chapterData: ChapterDetails.fromJson(json['chpterData'] ?? {}),
    );
  }
}

class Chapter {
  final int pk;
  final String name;
  final bool complete;

  Chapter({
    required this.pk,
    required this.name,
    required this.complete,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final rawComplete = json['complete'];
    final isComplete = rawComplete == true ||
        rawComplete == 1 ||
        rawComplete == 'true' ||
        rawComplete == '1';

    return Chapter(
      pk: json['pk'] ?? 0,
      name: json['name'] ?? '',
      complete: isComplete,
    );
  }
}

class ChapterDetails {
  final int? pk;
  final String name;
  final List<ChapterResources> resources;
  final List<String> comments;
  final List<ExamChapter> examChapters;
  final String publishDate;
  final bool? complete;

  ChapterDetails({
    this.pk,
    required this.name,
    required this.resources,
    required this.comments,
    required this.examChapters,
    required this.publishDate,
    this.complete,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    final rawComplete = json['complete'];
    final bool? isComplete = rawComplete != null
        ? (rawComplete == true ||
            rawComplete == 1 ||
            rawComplete == 'true' ||
            rawComplete == '1')
        : null;

    return ChapterDetails(
      pk: json['pk'],
      name: json['name'] ?? '',
      resources: (json['resources'] as List<dynamic>?)
              ?.map((e) => ChapterResources.fromJson(e))
              .toList() ??
          [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      examChapters: (json['exam_chapters'] as List<dynamic>?)
              ?.map((e) => ExamChapter.fromJson(e))
              .toList() ??
          [],
      publishDate: json['publish_date']?.toString() ?? '',
      complete: isComplete,
    );
  }
}

class ChapterResources {
  final String name;
  final String url;

  ChapterResources({required this.name, required this.url});

  factory ChapterResources.fromJson(Map<String, dynamic> json) {
    return ChapterResources(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class ExamChapter {
  final int pk;
  final String name;
  final List<Questions> questions;
  final bool foundAnswers;

  ExamChapter({
    required this.pk,
    required this.name,
    required this.questions,
    required this.foundAnswers,
  });

  factory ExamChapter.fromJson(Map<String, dynamic> json) {
    final rawFound = json['found_answers'];
    final isFound = rawFound == true ||
        rawFound == 1 ||
        rawFound == 'true' ||
        rawFound == '1';

    return ExamChapter(
      pk: json['pk'] ?? 0,
      name: json['name'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => Questions.fromJson(e))
              .toList() ??
          [],
      foundAnswers: isFound,
    );
  }
}

class Questions {
  final int pk;
  final String head;
  final String headImage;
  final String? a;
  final String? b;
  final String? c;
  final String? d;

  Questions({
    required this.pk,
    required this.head,
    required this.headImage,
    this.a,
    this.b,
    this.c,
    this.d,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      pk: json['pk'] ?? 0,
      head: json['head'] ?? '',
      headImage: json['head_image'] ?? '',
      a: json['A'],
      b: json['B'],
      c: json['C'],
      d: json['D'],
    );
  }
}
