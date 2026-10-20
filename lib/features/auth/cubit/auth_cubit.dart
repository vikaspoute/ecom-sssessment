import 'package:ecom/features/auth/cubit/auth_state.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> login({required String email, required String password}) async {
    if (state is AuthLoading) {
      return;
    }

    emit(const AuthLoading());

    final result = await _repository.login(email: email, password: password);

    if (isClosed) {
      return;
    }

    if (result.isSuccess) {
      emit(const AuthAuthenticated());
    } else {
      emit(AuthFailure(result.message ?? 'Unable to sign in.'));
    }
  }
}
