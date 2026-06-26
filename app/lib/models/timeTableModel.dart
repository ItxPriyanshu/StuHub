class Timetablemodel {
  final String id;

  final String subjectId;

  // 1=Mon, 2=Tue,....,7=Sun
  final int weekday;

  final int classCount;

  final bool synced;

  final DateTime createdAt;
  final DateTime updatedAt;
  Timetablemodel({
    required this.id,
    required this.subjectId,
    required this.weekday,
    required this.classCount,
    required this.synced,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'weekday': weekday,
      'class_count': classCount,
      'synced': synced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Timetablemodel.fromMap(Map<String, dynamic> map) {
    return Timetablemodel(
      id: map['id'],
      subjectId: map['subject_id'],
      weekday: map['weekday'],
      classCount: map['class_count'],
      synced: map['synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'subjectId': subjectId,
    'weekday': weekday,
    'classCount': classCount,
    'synced': synced,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
}
