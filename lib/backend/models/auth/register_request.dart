class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String loginType;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.loginType,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'login_type': loginType,
  };
}
