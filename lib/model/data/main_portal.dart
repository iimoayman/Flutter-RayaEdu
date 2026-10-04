
class MainPortal {
  final List<Chapter> chapters;
  final ChapterDetails chpterData;

  const MainPortal({
    required this.chapters,
    required this.chpterData,
  });

  factory MainPortal.fromJson(Map<String, dynamic> json) => MainPortal(
    chapters: (json['chapters'] as List<dynamic>? ?? [])
        .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
        .toList(),
    chpterData:
    ChapterDetails.fromJson(json['chpterData'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'chapters': chapters.map((e) => e.toJson()).toList(),
    'chpterData': chpterData.toJson(),
  };
}

// ---------------------------------------------------------

class Chapter {
  final int pk;
  final String name;
  final bool complete;

  const Chapter({
    required this.pk,
    required this.name,
    required this.complete,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    pk: json['pk'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    complete: json['complete'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'pk': pk,
    'name': name,
    'complete': complete,
  };
}

// ---------------------------------------------------------

class ChapterDetails {
  final int? pk;
  final String name;
  final List<ChapterResources> resources;
  final List<String> comments;
  final List<ExamChapter> examChapters;

  const ChapterDetails({
    this.pk,
    required this.name,
    required this.resources,
    required this.comments,
    required this.examChapters,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) => ChapterDetails(
    pk: json['pk'] as int?,
    name: json['name'] as String? ?? '',
    resources: (json['resources'] as List<dynamic>? ?? [])
        .map((e) => ChapterResources.fromJson(e as Map<String, dynamic>))
        .toList(),
    comments:
    (json['comments'] as List<dynamic>? ?? []).map((e) => '$e').toList(),
    examChapters: (json['exam_chapters'] as List<dynamic>? ?? [])
        .map((e) => ExamChapter.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'pk': pk,
    'name': name,
    'resources': resources.map((e) => e.toJson()).toList(),
    'comments': comments,
    'exam_chapters': examChapters.map((e) => e.toJson()).toList(),
  };
}

// ---------------------------------------------------------

class ChapterResources {
  final String name;
  final String url;

  const ChapterResources({required this.name, required this.url});

  factory ChapterResources.fromJson(Map<String, dynamic> json) =>
      ChapterResources(
        name: json['name'] as String? ?? '',
        url: json['url'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}

// ---------------------------------------------------------

class ExamChapter {
  final int pk;
  final String name;
  final List<Questions> questions;
  final bool foundAnswers;

  const ExamChapter({
    required this.pk,
    required this.name,
    required this.questions,
    required this.foundAnswers,
  });

  factory ExamChapter.fromJson(Map<String, dynamic> json) => ExamChapter(
    pk: json['pk'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    questions: (json['questions'] as List<dynamic>? ?? [])
        .map((e) => Questions.fromJson(e as Map<String, dynamic>))
        .toList(),
    foundAnswers: json['found_answers'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'pk': pk,
    'name': name,
    'questions': questions.map((e) => e.toJson()).toList(),
    'found_answers': foundAnswers,
  };
}

// ---------------------------------------------------------

class Questions {
  final int pk;
  final String head;
  final String headImage;
  final String? a;
  final String? b;
  final String? c;
  final String? d;

  const Questions({
    required this.pk,
    required this.head,
    required this.headImage,
    this.a,
    this.b,
    this.c,
    this.d,
  });

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
    pk: json['pk'] as int? ?? 0,
    head: json['head'] as String? ?? '',
    headImage: json['head_image'] as String? ?? '',
    a: json['A'] as String?,
    b: json['B'] as String?,
    c: json['C'] as String?,
    d: json['D'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'pk': pk,
    'head': head,
    'head_image': headImage,
    'A': a,
    'B': b,
    'C': c,
    'D': d,
  };
}