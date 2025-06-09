part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Checking if already signed in at startup
class CheckSignInRequested extends AuthEvent {}

// Email/Password Sign In/Sign Up
// User tapped "Create Account with Email and Password"
class EmailSignUpRequested extends AuthEvent {
  final String displayName;
  final String email;
  final String password;
  final String loginType;
  final String? profilePicUrl;
  final String? phoneNumber;

  EmailSignUpRequested(
    this.displayName,
    this.email,
    this.password,
    this.loginType,
    this.profilePicUrl,
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [
    email,
    password,
    loginType,
    displayName,
    profilePicUrl,
    phoneNumber,
  ];
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


// User tapped "Sign In with Google"
class GoogleSignInRequested extends AuthEvent {}

// User tapped "Sign Out"
class GoogleSignOutRequested extends AuthEvent {}
