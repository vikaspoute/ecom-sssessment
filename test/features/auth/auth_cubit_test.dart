import 'package:ecom/features/auth/cubit/auth_cubit.dart';
import 'package:ecom/features/auth/cubit/auth_state.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthCubit cubit;

  setUp(() {
    cubit = AuthCubit(const AuthRepository(delay: Duration.zero));
  });

  tearDown(() async {
    await cubit.close();
  });

  test('starts in the initial state', () {
    expect(cubit.state, const AuthInitial());
  });

  test('emits loading then authenticated for demo credentials', () async {
    final states = <AuthState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.login(
      email: AuthRepository.demoEmail,
      password: AuthRepository.demoPassword,
    );
    await pumpEventQueue();
    await subscription.cancel();

    expect(states, const [AuthLoading(), AuthAuthenticated()]);
  });

  test('emits loading then failure for invalid credentials', () async {
    final states = <AuthState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.login(email: 'wrong@ecom.app', password: 'WrongPass123');
    await pumpEventQueue();
    await subscription.cancel();

    expect(states.first, const AuthLoading());
    expect(states.last, isA<AuthFailure>());
    expect(
      (states.last as AuthFailure).message,
      AuthRepository.invalidCredentialsMessage,
    );
  });

  test('ignores duplicate submissions while loading', () async {
    final repository = _SlowAuthRepository();
    final delayedCubit = AuthCubit(repository);
    addTearDown(delayedCubit.close);

    final first = delayedCubit.login(
      email: AuthRepository.demoEmail,
      password: AuthRepository.demoPassword,
    );
    final second = delayedCubit.login(
      email: AuthRepository.demoEmail,
      password: AuthRepository.demoPassword,
    );

    await Future.wait([first, second]);

    expect(repository.calls, 1);
    expect(delayedCubit.state, const AuthAuthenticated());
  });
}

class _SlowAuthRepository extends AuthRepository {
  _SlowAuthRepository() : super(delay: Duration.zero);

  var calls = 0;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    calls += 1;
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return const AuthResult.success();
  }
}
