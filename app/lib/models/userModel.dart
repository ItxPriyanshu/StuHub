class Usermodel {
  final String id;
  final String name;
  final String email;
  Usermodel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Usermodel.fromJson(Map<String,dynamic> json){
    return Usermodel(id: json["id"], name: json["name"], email: json["email"]);
  }
}
