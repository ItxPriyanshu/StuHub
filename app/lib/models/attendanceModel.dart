class Attendancemodel {
  final String id;
  final String subjectId;
  final String date;
  final int totalClasses;
  final int attendedClasses;
  final String status;
  final DateTime  createdAt;
  final DateTime updatedAt;
  Attendancemodel({
    required this.id,
    required this.subjectId,
    required this.date,
    required this.totalClasses,
    required this.attendedClasses,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

Map<String,dynamic> toMap(){
  return {
    "id": id,
      "subjectId": subjectId,
      "date": date,
      "totalClasses": totalClasses,
      "attendedClasses": attendedClasses,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
  };
}


factory Attendancemodel.fromMap(Map<String,dynamic> map){
  return Attendancemodel(
      id: map["id"],
      subjectId: map["subjectId"],
      date: map["date"],
      totalClasses: map["totalClasses"],
      attendedClasses: map["attendedClasses"],
      status: map["status"],
      createdAt: DateTime.parse(map["createdAt"]),
      updatedAt: DateTime.parse(map["updatedAt"]),
    );
}

  Attendancemodel copyWith({
     String? id,
    String? subjectId,
    String? date,
    int? totalClasses,
    int? attendedClasses,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }){
     return Attendancemodel(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      date: date ?? this.date,
      totalClasses: totalClasses ?? this.totalClasses,
      attendedClasses: attendedClasses ?? this.attendedClasses,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
