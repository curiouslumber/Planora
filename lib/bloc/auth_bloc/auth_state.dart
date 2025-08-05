part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial / unknown authentication status
final class AuthInitial extends AuthState {}

// Waiting for sign-in/sign-out to complete
final class AuthLoading extends AuthState {}

// Signed-in succesfully
final class Authenticated extends AuthState {
  final UserModel user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Not signed in
final class Unauthenticated extends AuthState {}

// An Error occured
final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
