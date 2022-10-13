part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthInitialEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class OnSignInEvent extends AuthEvent{
  final String email;
  final String password;
  const OnSignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class OnSignUpEvent extends AuthEvent{
  final String email;
  final String password;
  final String name;
  const OnSignUpEvent({required this.email, required this.password, required this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class OnForgetPasswordEvent extends AuthEvent{
  final String email;
  const OnForgetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class OnLogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}