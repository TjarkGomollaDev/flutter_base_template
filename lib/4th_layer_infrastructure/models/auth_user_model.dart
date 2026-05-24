class AuthUserModel {
  final String id;
  final String? name;
  final String? email;

  const AuthUserModel({
    required this.id,
    this.name,
    this.email,
  });

  static const empty = AuthUserModel(id: '');

  bool get isEmpty => this == AuthUserModel.empty;
  bool get isNotEmpty => this != AuthUserModel.empty;
}
