part of 'google_sign_in_bloc.dart';

@immutable
abstract class GoogleSignInEvent {}

class GoogleSignInEventSignIn extends GoogleSignInEvent {
  final String email;
  final String password;

  GoogleSignInEventSignIn({required this.email, required this.password});
}

class GoogleSignInEventSignOut extends GoogleSignInEvent {}

class GoogleSignInEventCheckLogin extends GoogleSignInEvent {}
