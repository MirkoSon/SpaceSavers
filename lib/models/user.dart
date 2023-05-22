class UserModel {
  final String id;
  final String email;
  String? name;
  String? avatarUrl;
  int credits;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.credits = 0,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'],
        avatarUrl = json['avatar_url'],
        credits = json['credits'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar_url': avatarUrl,
        'credits': credits,
      };
}
