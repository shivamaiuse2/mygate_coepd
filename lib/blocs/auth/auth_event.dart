import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phone;
  final String otp;

  const LoginRequested({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String societyId;
  final String unit;
  final String role;

  const RegisterRequested({
    required this.name,
    required this.phone,
    required this.societyId,
    required this.unit,
    required this.role,
  });

  @override
  List<Object?> get props => [name, phone, societyId, unit, role];
}

class LogoutRequested extends AuthEvent {}

class RoleSelected extends AuthEvent {
  final String role;

  const RoleSelected({required this.role});

  @override
  List<Object?> get props => [role];
}

class OnboardingCompleted extends AuthEvent {}