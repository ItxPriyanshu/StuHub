import 'package:intl/intl.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/todayClassModel.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';
import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/repositories/timetableRepository.dart';

class Homerepository {
  final Timetablerepository timetableRepo = Timetablerepository();
  final Attendancerepository attendanceRepo = Attendancerepository(DatabaseHelper.instance);

  final Subjectrepository subjectRepo = Subjectrepository();

Future<List<Todayclassmodel>> getTodayClasses() async {
  final session = await Sessionrepository().getSession();
  if(session == null){
    return [];
  }
  final today = DateTime.now();

  final sessionStart = DateTime(
    session.startDate.year,
    session.startDate.month,
    session.startDate.day,
  );
  final sessionEnd = DateTime(
    session.endDate.year,
    session.endDate.month,
    session.endDate.day,
    23,
    59,
    59,
  );
    if (today.isBefore(sessionStart)) {
    return [];
  }
    if (today.isAfter(sessionEnd)) {
    return [];
  }

  final weekday = today.weekday;

  final timetables =
      await timetableRepo.getTimetableByDay(weekday);

  final todayDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<Todayclassmodel> classes = [];

  for (final timetable in timetables) {
    final subject =
        await subjectRepo.getSubjectById(
      timetable.subjectId,
    );

    if (subject == null) continue;

    final alreadyMarked =
        await attendanceRepo.isAttendanceMarked(
      subjectId: subject.id,
      date: todayDate,
    );

    if (alreadyMarked) continue;

    classes.add(
      Todayclassmodel(
        subjectId: subject.id,
        subjectName: subject.name,
        classCount: timetable.classCount,
      ),
    );
  }

  return classes;
}
}
