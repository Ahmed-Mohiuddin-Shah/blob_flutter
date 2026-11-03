import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:blob_flutter/configs/utils/xutils.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SplashPhase { booting, forceUpdate, ready }

class SplashState extends Equatable {
  const SplashState({this.phase = SplashPhase.booting, this.message});

  final SplashPhase phase;
  final String? message;

  @override
  List<Object?> get props => [phase, message];
}

class SplashCubit extends Cubit<SplashState> with XSafeEmitMixin {
  SplashCubit() : super(const SplashState());

  Future<void> boot() async {
    await AppGlobals.authCubit.restoreSession();
    if (AppGlobals.authCubit.state.status == AuthStatus.signedIn) {
      await AppGlobals.meCubit.load();
    }
    await AppGlobals.appVersionCubit.check();
    final version = AppGlobals.appVersionCubit.state;
    if (version.isForceUpdate) {
      final url = version.check?.storeUrl;
      if (url != null && url.isNotEmpty) {
        await XUtils.launchURL(url);
      }
      xSafeEmit(
        SplashState(
          phase: SplashPhase.forceUpdate,
          message: version.check?.message ?? 'Update required',
        ),
      );
      return;
    }
    xSafeEmit(const SplashState(phase: SplashPhase.ready));
  }
}
