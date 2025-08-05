class RegisterResponse {
  final bool status;
  final String message;
  final Object data;

  RegisterResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        status: json['status'],
        message: json['message'],
        data: json['data'],
      );
}
