class StuServices {
  final String service;
  final String status;
  final String acceptDate;
  final String? addressed;
  final String? notesStudent;
  final String? notes;

  const StuServices({
    required this.service,
    required this.status,
    required this.acceptDate,
    this.addressed,
    this.notesStudent,
    this.notes,
  });

  factory StuServices.fromJson(Map<String, dynamic> json) => StuServices(
    service: json['service'] as String? ?? '',
    status: json['status'] as String? ?? '',
    acceptDate: json['accept_date'] as String? ?? '',
    addressed: json['addressed'] as String?,
    notesStudent: json['notes_student'] as String?,
    notes: json['notes'] as String?,
  );
}