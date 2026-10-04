class StudentAchievements {
  final int countMaterials;           // count_materials
  final int countChapters;            // count_chapters
  final int countCompletedChapters;   // count_completed_chapters
  final int countExamChapters;        // count_examChapters
  final int countExamChaptersDone;    // count_examChapters_done
  final double attendanceRate;        // attendanceRate

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
        countMaterials: _toInt(json['count_materials']),
        countChapters: _toInt(json['count_chapters']),
        countCompletedChapters: _toInt(json['count_completed_chapters']),
        countExamChapters: _toInt(json['count_examChapters']),
        countExamChaptersDone: _toInt(json['count_examChapters_done']),
        attendanceRate: _toDouble(json['attendanceRate']),
      );

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }
}