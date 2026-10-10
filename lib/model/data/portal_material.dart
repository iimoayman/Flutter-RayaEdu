class MainPortal {
  final List<Chapter> chapters;
  final ChapterDetails chpterData;

  const MainPortal({required this.chapters, required this.chpterData});

  factory MainPortal.fromJson(Map<String, dynamic> j) => MainPortal(
    chapters: (j['chapters'] as List? ?? [])
        .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
        .toList(),
    chpterData:
    ChapterDetails.fromJson(j['chpterData'] as Map<String, dynamic>),
  );
}

class Chapter {
  final int pk;
  final String name;
  final bool complete;

  const Chapter({
    required this.pk,
    required this.name,
    required this.complete,
  });

  factory Chapter.fromJson(Map<String, dynamic> j) => Chapter(
    pk: (j['pk'] as num?)?.toInt() ?? 0,
    name: j['name'] as String? ?? '',
    complete: j['complete'] as bool? ?? false,
  );
}

class ChapterDetails {
  final int? pk;
  final String name;
  final List<ChapterResources> resources;
  final List<String> comments;
  final List<ExamChapter> examChapters;
  final String publishDate;

  const ChapterDetails({
    this.pk,
    required this.name,
    required this.resources,
    required this.comments,
    required this.examChapters,
    required this.publishDate,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> j) => ChapterDetails(
    pk: (j['pk'] as num?)?.toInt(),
    name: j['name'] as String? ?? '',
    resources: (j['resources'] as List? ?? [])
        .map((e) => ChapterResources.fromJson(e as Map<String, dynamic>))
        .toList(),
    comments:
    (j['comments'] as List? ?? []).map((e) => e.toString()).toList(),
    examChapters: (j['exam_chapters'] as List? ?? [])
        .map((e) => ExamChapter.fromJson(e as Map<String, dynamic>))
        .toList(),
    publishDate: j['publish_date'] as String? ?? '',
  );
}

/// Mirrors `ChapterResources`
class ChapterResources {
  final String name;
  final String url;

  const ChapterResources({required this.name, required this.url});

  factory ChapterResources.fromJson(Map<String, dynamic> j) => ChapterResources(
    name: j['name'] as String? ?? '',
    url: j['url'] as String? ?? '',
  );
}

/// Mirrors `ExamChapter`
class ExamChapter {
  final int pk;
  final String name;
  final List<Questions> questions;
  final bool foundAnswers;  // found_answers

  const ExamChapter({
    required this.pk,
    required this.name,
    required this.questions,
    required this.foundAnswers,
  });

  factory ExamChapter.fromJson(Map<String, dynamic> j) => ExamChapter(
    pk: (j['pk'] as num?)?.toInt() ?? 0,
    name: j['name'] as String? ?? '',
    questions: (j['questions'] as List? ?? [])
        .map((e) => Questions.fromJson(e as Map<String, dynamic>))
        .toList(),
    foundAnswers: j['found_answers'] as bool? ?? false,
  );
}

/// Mirrors `Questions`
class Questions {
  final int pk;
  final String head;
  final String headImage;   // head_image
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

  factory Questions.fromJson(Map<String, dynamic> j) => Questions(
    pk: (j['pk'] as num?)?.toInt() ?? 0,
    head: j['head'] as String? ?? '',
    headImage: j['head_image'] as String? ?? '',
    a: j['A'] as String?,
    b: j['B'] as String?,
    c: j['C'] as String?,
    d: j['D'] as String?,
  );
}