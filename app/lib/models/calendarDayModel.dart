class Calendardaymodel {
  final DateTime date;
  final bool inCurrentMonth;
  final bool inSession;

  final String? status;

  final int classCount;
  Calendardaymodel({
    required this.date,
    required this.inCurrentMonth,
    required this.inSession,
    this.status,
    required this.classCount,
  });

  
}
