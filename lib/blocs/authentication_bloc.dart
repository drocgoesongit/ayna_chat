import 'package:ayna_chat/events/authentication_events.dart';
import 'package:ayna_chat/events/authentication_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationUninitialized()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final bool isAuthenticated = await _checkIfAuthenticated();

    if (isAuthenticated) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(
      LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthencationError(
          message:
              'Login failed. Try signing up. The email or password might be incorrect.',
        ));
        emit(AuthenticationUnauthenticated());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      emit(AuthencationError(message: errorMessage));
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthencationError(message: 'An unexpected error occurred.'));
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> _onLoggedOut(
      LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    await FirebaseAuth.instance.signOut();
    await _clearToken();
    emit(AuthenticationUnauthenticated());
  }

  Future<bool> _checkIfAuthenticated() async {
    // Implement your authentication check logic here
    return false;
  }

  Future<void> _saveToken(String token) async {
    // Implement your token saving logic here
  }

  Future<void> _clearToken() async {
    // Implement your token clearing logic here
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': event.email,
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(AuthenticationAuthenticated());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      emit(AuthencationError(message: errorMessage));
      emit(AuthenticationUnauthenticated());
    } on FirebaseException catch (e) {
      emit(AuthencationError(message: 'Could not store user information.'));
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthencationError(message: 'An unexpected error occurred.'));
      emit(AuthenticationUnauthenticated());
    }
  }
}
