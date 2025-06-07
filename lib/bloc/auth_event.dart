part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// User tapped "Sign In with Google"
class GoogleSignInRequested extends AuthEvent {}

// User tapped "Sign Out"
class GoogleSignOutRequested extends AuthEvent {}

// Checking if already signed in at startup
class GoogleSignInCheckRequested extends AuthEvent {}

// User tapped "Create Account with Email and Password"
class EmailSignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String loginType;

  EmailSignUpRequested(this.name, this.email, this.password, this.loginType);

  @override
  List<Object?> get props => [email, password];
}

// User tapped "Sign In with Email and Password"
class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  EmailSignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// User tapped "Sign Out"
class EmailSignOutRequested extends AuthEvent {}
