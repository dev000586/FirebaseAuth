part of 'auth_bloc.dart';

class AuthState{
  final StateStatus loginStatus;
  final StateStatus signupStatus;
  final StateStatus forgetPasswordStatus;
  final StateStatus logoutStatus;

  AuthState({
    this.loginStatus = const StateNotLoaded(),
    this.signupStatus = const StateNotLoaded(),
    this.forgetPasswordStatus = const StateNotLoaded(),
    this.logoutStatus = const StateNotLoaded()
  });

  AuthState get initialState => AuthState();

  AuthState copyWith({
    final StateStatus? loginStatus,
    final StateStatus? signupStatus,
    final StateStatus? forgetPasswordStatus,
    final StateStatus? logoutStatus,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      signupStatus: signupStatus ?? this.signupStatus,
      forgetPasswordStatus: forgetPasswordStatus ?? this.forgetPasswordStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  String toString() {
    return 'AuthState{loginStatus: $loginStatus, signupStatus: $signupStatus, forgetPasswordStatus: $forgetPasswordStatus, logoutStatus: $logoutStatus}';
  }
}
