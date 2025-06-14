import 'package:planora/backend/models/auth/login_request.dart';
import 'package:planora/backend/models/auth/login_response.dart';
import 'package:planora/backend/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<LoginResponse> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    return await _authService.login(request);
  }
}
