final class UserMd {
  final String id;
  final String name;
  final String email;
  final String phone;

  ///generated pin using sha1 password generator [password.substring(0,6)]
  final String pin;

  ///sha1 password generator using crypto package, with email, name and phone number as salt
  final String password;
  final bool isAdmin;
  final DateTime createdAt;
  final bool isBanned;

  final bool isReviewedByAdmin;

  const UserMd({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.phone,
    required this.isBanned,
    required this.pin,
    required this.password,
    required this.isAdmin,
    this.isReviewedByAdmin = false,
  });

  //from json
  factory UserMd.fromJson(Map<String, dynamic> json) => UserMd(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        pin: json['pin'] as String,
        password: json['password'] as String,
        isAdmin: json['isAdmin'] as bool,
        createdAt: json['createdAt'] == null
            ? DateTime.now()
            : DateTime.parse(
                json['createdAt'] as String,
              ),
        isBanned: (json['isBanned'] ?? false) as bool,
        isReviewedByAdmin: (json['isReviewedByAdmin'] ?? false) as bool,
      );

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'pin': pin,
        'password': password,
        'isAdmin': isAdmin,
        'createdAt': createdAt.toIso8601String(),
        'isBanned': isBanned,
        'isReviewedByAdmin': isReviewedByAdmin,
      };
}
