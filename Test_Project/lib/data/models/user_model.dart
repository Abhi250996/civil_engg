class UserModel {
  final String id;
  final String name;
  final String email;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  /// =========================
  /// FROM JSON
  /// =========================

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
    );
  }

  /// =========================
  /// TO JSON
  /// =========================

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email, "token": token};
  }

  /// =========================
  /// COPY WITH
  /// =========================

  UserModel copyWith({String? id, String? name, String? email, String? token}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
