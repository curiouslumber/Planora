import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<GoogleSignOutRequested>(_onGoogleSignOutRequested);

    // Initial Check
    add(CheckSignInRequested());
  }

  Future<bool> checkUserExists(String email) async {
    final userDoc = await _authRepository.getUserDocumentByEmail(email);
    if (userDoc == null) {
      return false;
    }

    return true;
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
      // Check if user exists
      final userExists = await checkUserExists(event.email);
      if (userExists) {
        emit(AuthError('User already exists'));
        return;
      }

      // Firebase Auth
      final user = await _authRepository
          .createFirebaseAuthUserWithEmailAndPassword(
            event.email,
            event.password,
          );
      if (user is! User) {
        emit(AuthError(user.toString()));
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
  // Event handlers
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user is! User) {
        emit(AuthError(user.toString()));
        return;
      }
      // Check if user exists
      final userExists = await checkUserExists(user.email!);
      if (userExists) {
        final userDoc = await _authRepository.getUserDocument(user.uid);
        if (userDoc == null) {
          emit(AuthError('User not found'));
          return;
        }
        emit(Authenticated(userDoc));
        return;
      }

      // Firebase Firestore
      await _authRepository.createFirebaseFirestoreUserWithEmailAndPassword(
        user.uid,
        user.email!,
        user.displayName!,
        user.photoURL,
        user.phoneNumber,
        'GOOGLE',
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
      if (user is! User) {
        emit(AuthError(user.toString()));
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
