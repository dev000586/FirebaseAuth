import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firbase_auth/bloc/event_status.dart';
import 'package:firbase_auth/helper/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<AuthInitialEvent>(_authInitialEvent);
    on<OnSignInEvent>(_onSignInEvent);
    on<OnSignUpEvent>(_onSignUpEvent);
    on<OnForgetPasswordEvent>(_onForgetPasswordEvent);
    on<OnLogoutEvent>(_onLogoutEvent);
  }

  FutureOr<void> _authInitialEvent(AuthInitialEvent event, Emitter<AuthState> emit) {
    emit(state.initialState);
  }

  FutureOr<void> _onSignInEvent(OnSignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: StateLoading()));
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: event.email, password: event.password);
      final pref = await SharedPreferences.getInstance();
      pref.setBool(AppConstants.ISLOGGEDIN, true);
      pref.setString(AppConstants.USERNAME, userCredential.user!.displayName?? 'User');
      emit(state.copyWith(loginStatus: const StateLoaded(successMessage: "Logged in Successfully.")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(loginStatus: const StateFailed(errorMessage: "User not found.")));
      } else if (e.code == 'wrong-password') {
        emit(state.copyWith(loginStatus: const StateFailed(errorMessage: "Incorrect Password")));
      }
    } catch(e){
      emit(state.copyWith(loginStatus: const StateFailed(errorMessage: "Error in Logging in.")));
    }
  }

  FutureOr<void> _onSignUpEvent(OnSignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(signupStatus: StateLoading()));
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: event.email, password: event.password);
      userCredential.user!.updateDisplayName(event.name);
      final pref = await SharedPreferences.getInstance();
      pref.setString(AppConstants.USERNAME, userCredential.user!.displayName?? 'User');
      emit(state.copyWith(signupStatus: const StateLoaded(successMessage: "Signup Successfully.")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(state.copyWith(signupStatus: const StateFailed(errorMessage: "Weak Password")));
      } else if (e.code == 'email-already-in-use') {
        emit(state.copyWith(signupStatus: const StateFailed(errorMessage: "Email already in use")));
      }
    } catch(e){
      print("===========$e");
      emit(state.copyWith(signupStatus: const StateFailed(errorMessage: "Error in Signing up.")));
    }
  }

  FutureOr<void> _onForgetPasswordEvent(OnForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(forgetPasswordStatus: StateLoading()));
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.sendPasswordResetEmail(email: event.email);
      emit(state.copyWith(forgetPasswordStatus: const StateLoaded(successMessage: "Password reset email is sent")));
    } catch(e){
      emit(state.copyWith(forgetPasswordStatus: const StateFailed(errorMessage: "Error in Logging in.")));
    }
  }

  FutureOr<void> _onLogoutEvent(OnLogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(logoutStatus: StateLoading()));
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      final pref = await SharedPreferences.getInstance();
      pref.setString(AppConstants.USERNAME, "User");
      pref.setBool(AppConstants.ISLOGGEDIN, false);
      emit(state.copyWith(logoutStatus: const StateLoaded(successMessage: "Logout Successfully.")));
    } catch(e){
      emit(state.copyWith(logoutStatus: const StateFailed(errorMessage: "Error in logging out.")));
    }
  }
}
