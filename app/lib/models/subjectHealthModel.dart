// ignore_for_file: public_member_api_docs, sort_constructors_first

class Subjecthealthmodel {
  final String subjectId;
  final String subjectName;

  final int presentClasses;
  final int absentClasses;
  final int holidayClasses;
  final double attendancePercentage;
  Subjecthealthmodel({
    required this.subjectId,
    required this.subjectName,
    required this.presentClasses,
    required this.absentClasses,
    required this.holidayClasses,
    required this.attendancePercentage,
  });
}
