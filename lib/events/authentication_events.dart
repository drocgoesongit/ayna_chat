import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String email;
  final String password;

  LoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LoggedOut extends AuthenticationEvent {}

class SignUpRequested extends AuthenticationEvent {
  final String email;
  final String password;

  SignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
