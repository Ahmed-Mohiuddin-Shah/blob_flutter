import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/app_version/app_version_repo.dart';
import 'package:blob_flutter/data/models/app_version/app_version_check_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppVersionState extends Equatable {
  const AppVersionState({this.check, this.loading = false, this.error});

  final AppVersionCheckModel? check;
  final bool loading;
  final String? error;

  bool get isForceUpdate => check?.status == 'force_update';
  bool get isSuggestUpdate => check?.status == 'suggest_update';

  AppVersionState copyWith({
    AppVersionCheckModel? check,
    bool? loading,
    String? error,
  }) => AppVersionState(
    check: check ?? this.check,
    loading: loading ?? this.loading,
    error: error,
  );

  @override
  List<Object?> get props => [check, loading, error];
}

class AppVersionCubit extends Cubit<AppVersionState> with XSafeEmitMixin {
  AppVersionCubit() : super(const AppVersionState());

  Future<void> check() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final result = await AppVersionRepo.check();
    xSafeEmit(
      state.copyWith(
        loading: false,
        check: result.data,
        error: result.error?.message,
      ),
    );
  }
}
