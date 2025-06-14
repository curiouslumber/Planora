class LoginResponse {
  final bool status;
  final String message;
  final Object data;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    status: json['status'],
    message: json['message'],
    data: json['data'],
  );
}
