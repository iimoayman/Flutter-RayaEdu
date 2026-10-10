class StudentAchievements {
  final int countMaterials;
  final int countChapters;
  final int countCompletedChapters;
  final int countExamChapters;
  final int countExamChaptersDone;
  final double attendanceRate;

  const StudentAchievements({
    required this.countMaterials,
    required this.countChapters,
    required this.countCompletedChapters,
    required this.countExamChapters,
    required this.countExamChaptersDone,
    required this.attendanceRate,
  });

  factory StudentAchievements.fromJson(Map<String, dynamic> json) =>
      StudentAchievements(
        countMaterials: (json['count_materials'] as num?)?.toInt() ?? 0,
        countChapters: (json['count_chapters'] as num?)?.toInt() ?? 0,
        countCompletedChapters:
        (json['count_completed_chapters'] as num?)?.toInt() ?? 0,
        countExamChapters:
        (json['count_examChapters'] as num?)?.toInt() ?? 0,
        countExamChaptersDone:
        (json['count_examChapters_done'] as num?)?.toInt() ?? 0,
        attendanceRate:
        (json['attendanceRate'] as num?)?.toDouble() ?? 0.0,
      );

  static const empty = StudentAchievements(
    countMaterials: 0,
    countChapters: 0,
    countCompletedChapters: 0,
    countExamChapters: 0,
    countExamChaptersDone: 0,
    attendanceRate: 0.0,
  );
}