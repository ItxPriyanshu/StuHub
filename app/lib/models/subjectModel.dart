class Subjectmodel {
  final String id;
  final String name;

  final double requiredAttendance;

  final bool synced;

  final DateTime createdAt;
  final DateTime updatedAt;
  Subjectmodel({
    required this.id,
    required this.name,
    required this.requiredAttendance,
    required this.synced,
    required this.createdAt,
    required this.updatedAt,
  });
Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'required_attendance': requiredAttendance,
      'synced': synced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  
}
