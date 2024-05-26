class User {
  String id;
  String name;
  String email;
  double wallet;
  String? image;
  String? phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.wallet,
    this.image,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      wallet: json['wallet'],
      image: json['image'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'wallet': wallet,
      'image': image,
      'phone': phone,
    };
  }
}
