import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';   // ✅ Import NoParams here

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  void _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    final result = await loginUseCase.getCurrentUser();
    result.fold(
      (failure) => emit(UnauthenticatedState()),
      (user) {
        if (user != null) {
          emit(AuthenticatedState(user: user));
        } else {
          emit(UnauthenticatedState());
        }
      },
    );
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthErrorState(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await registerUseCase(RegisterParams(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      role: event.role,
      department: event.department,
      phone: event.phone,
    ));

    result.fold(
      (failure) => emit(AuthErrorState(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await logoutUseCase(NoParams());   // ✅ Now works
    result.fold(
      (failure) => emit(AuthErrorState(message: _mapFailureToMessage(failure))),
      (_) => emit(UnauthenticatedState()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'No internet connection. Please check your network.';
      case AuthFailure:
        return failure.message ?? 'Authentication failed.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
