import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckSignInRequested>(_checkSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);

    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<EmailSignUpRequested>(_onEmailSignUpRequested);
    on<EmailSignOutRequested>(_onEmailSignOutRequested);

    on<GoogleSignOutRequested>(_onGoogleSignOutRequested);

    // Initial Check
    add(CheckSignInRequested());
  }


  // Event handlers
  Future<void> _checkSignInRequested(
    CheckSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authRepository.currentUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // Event handlers
  Future<void> _onEmailSignUpRequested(
    EmailSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Firebase Auth
      final user = await _authRepository
          .createFirebaseAuthUserWithEmailAndPassword(
            event.email,
            event.password,
          );
      if (user == null) {
        emit(AuthError('User not created'));
        return;
      }

      // Firebase Firestore
      await _authRepository.createFirebaseFirestoreUserWithEmailAndPassword(
        user.uid,
        event.email,
        event.displayName,
        event.profilePicUrl,
        event.phoneNumber,
        event.loginType,
      );

      final userDoc = await _authRepository.getUserDocument(user.uid);
      if (userDoc == null) {
        emit(AuthError('User not found'));
        return;
      }

      emit(Authenticated(userDoc));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Event handlers
  Future<void> _onSignOutRequested(
    SignOutRequested event,
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

  // Update this later to have business logic
  // // Event handlers
  // Future<void> _onGoogleSignInRequested(
  //   GoogleSignInRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   try {
  //     final user = await _authRepository.signInWithGoogle();
  //     if (user != null) {
  //       emit(Authenticated(user));
  //     } else {
  //       emit(Unauthenticated());
  //     }
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  // Event handlers
  Future<void> _onGoogleSignOutRequested(
    GoogleSignOutRequested event,
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


  // Event handlers
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
      if (user == null) {
        emit(AuthError('User not found'));
        return;
      }

      final userDoc = await _authRepository.getUserDocument(user.uid);
      if (userDoc == null) {
        emit(AuthError('User not found'));
        return;
      }

      emit(Authenticated(userDoc));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Event handlers
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
