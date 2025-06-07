part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Email Password Events
class EmailSignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String loginType;

  EmailSignUpRequested(this.name, this.email, this.password, this.loginType);

  @override
  List<Object?> get props => [email, password];
}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  EmailSignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class EmailSignOutRequested extends AuthEvent {}

// Google Events
class GoogleSignInRequested extends AuthEvent {}

class GoogleSignOutRequested extends AuthEvent {}

// Checking if already signed in at startup
class GoogleSignInCheckRequested extends AuthEvent {}
