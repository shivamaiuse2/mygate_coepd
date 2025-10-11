import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygate_coepd/models/user.dart';
import 'package:mygate_coepd/repositories/user_repository.dart';
import 'package:mygate_coepd/config/app_config.dart';
import 'package:mygate_coepd/blocs/auth/auth_event.dart';
import 'package:mygate_coepd/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc({required this.userRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RoleSelected>(_onRoleSelected);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    // Initialize user repository
    await userRepository.init();

    // Check if onboarding is complete
    if (!AppConfig.isOnboardingComplete) {
      emit(OnboardingState());
      return;
    }

    // Check if user is already logged in
    final user = userRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await userRepository.login(event.phone, event.otp);
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  void _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await userRepository.register(
        name: event.name,
        phone: event.phone,
        societyId: event.societyId,
        unit: event.unit,
        role: event.role,
      );
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await userRepository.logout();
    emit(Unauthenticated());
  }

  void _onRoleSelected(RoleSelected event, Emitter<AuthState> emit) {
    AppConfig.setSelectedRole(event.role);
    emit(RoleSelectedState(role: event.role));
  }

  void _onOnboardingCompleted(
      OnboardingCompleted event, Emitter<AuthState> emit) async {
    await AppConfig.setOnboardingComplete(true);
    emit(Unauthenticated());
  }
}