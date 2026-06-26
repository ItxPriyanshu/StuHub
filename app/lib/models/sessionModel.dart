class Sessionmodel {
  final String id;

  final DateTime startDate;
  final DateTime endDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  final bool synced;
  Sessionmodel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.synced,
  });
  Map<String,dynamic> toMap() {
  return {
    "id": id,
    "startDate":
        startDate.toIso8601String(),
    "endDate":
        endDate.toIso8601String(),
    "synced": synced,
    "createdAt":
        createdAt.toIso8601String(),
    "updatedAt":
        updatedAt.toIso8601String(),
  };
}

}
