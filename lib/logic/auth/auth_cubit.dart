import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/auth/zitadel_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.busy = false,
    this.error,
  });

  final AuthStatus status;
  final bool busy;
  final String? error;

  AuthState copyWith({
    AuthStatus? status,
    bool? busy,
    String? error,
  }) =>
      AuthState(
        status: status ?? this.status,
        busy: busy ?? this.busy,
        error: error,
      );

  @override
  List<Object?> get props => [status, busy, error];
}

class AuthCubit extends Cubit<AuthState> with XSafeEmitMixin {
  AuthCubit() : super(const AuthState());

  Future<void> restoreSession() async {
    final has = await ZitadelAuth.hasSession();
    xSafeEmit(
      state.copyWith(
        status: has ? AuthStatus.signedIn : AuthStatus.signedOut,
      ),
    );
  }

  Future<bool> signIn() async {
    xSafeEmit(state.copyWith(busy: true, error: null));
    final ok = await ZitadelAuth.signIn();
    xSafeEmit(
      state.copyWith(
        busy: false,
        status: ok ? AuthStatus.signedIn : AuthStatus.signedOut,
        error: ok ? null : 'Sign-in failed',
      ),
    );
    return ok;
  }

  Future<void> signOut() async {
    await ZitadelAuth.signOut();
    xSafeEmit(state.copyWith(status: AuthStatus.signedOut, busy: false));
  }
}
