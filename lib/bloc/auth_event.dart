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
