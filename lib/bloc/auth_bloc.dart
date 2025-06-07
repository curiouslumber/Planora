import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:planora/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<EmailSignUpRequested>(_onEmailSignUpRequested);
    on<EmailSignOutRequested>(_onEmailSignOutRequested);
  }

  Future<void> _onEmailSignInRequested(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(
        event.email,
        event.password,
      );
      if (user == null || user.user == null) {
        emit(AuthError('User not found'));
      }
      if (user != null && user.user != null) {
        emit(Authenticated(user.user!));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmailSignUpRequested(
    EmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUpNewUser(
        event.email,
        event.password,
      );
      if (user != null && user.user != null) {
        emit(Authenticated(user.user!));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onEmailSignOutRequested(
    EmailSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
