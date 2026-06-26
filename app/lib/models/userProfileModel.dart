class Userprofilemodel {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final DateTime updatedAt;
  Userprofilemodel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "profile_image": profileImage,
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  factory Userprofilemodel.fromMap(Map<String,dynamic> map){
    return Userprofilemodel(
      id: map["id"],
      username: map["username"],
      email: map["email"],
      profileImage: map["profile_image"],
      updatedAt: DateTime.parse(
        map["updated_at"],
      ),
    );
  }
}
