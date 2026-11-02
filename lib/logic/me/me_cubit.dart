import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/me/me_repo.dart';
import 'package:blob_flutter/data/models/me/me_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeState extends Equatable {
  const MeState({this.me, this.loading = false, this.error});

  final MeModel? me;
  final bool loading;
  final String? error;

  MeState copyWith({MeModel? me, bool? loading, String? error}) => MeState(
        me: me ?? this.me,
        loading: loading ?? this.loading,
        error: error,
      );

  @override
  List<Object?> get props => [me, loading, error];
}

class MeCubit extends Cubit<MeState> with XSafeEmitMixin {
  MeCubit() : super(const MeState());

  Future<void> load() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final result = await MeRepo.getMe();
    xSafeEmit(
      state.copyWith(
        loading: false,
        me: result.data,
        error: result.error?.message,
      ),
    );
  }

  void clear() => xSafeEmit(const MeState());
}
