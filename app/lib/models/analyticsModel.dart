class Analyticsmodel {
  final String subjectId;
  final String subjectName;

  final int present;
  final int absent;
  final int holiday;

  final int totalClasses;

  final double attendancePercentage;

  final int canMiss;

  final int needToAttend;
  Analyticsmodel({
    required this.subjectId,
    required this.subjectName,
    required this.present,
    required this.absent,
    required this.holiday,
    required this.totalClasses,
    required this.attendancePercentage,
    required this.canMiss,
    required this.needToAttend,
  });
  
}
