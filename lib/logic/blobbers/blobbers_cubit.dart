import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/blobbers/blobbers_repo.dart';
import 'package:blob_flutter/data/models/blobbers/blobber_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobbersState extends Equatable {
  const BlobbersState({
    this.items = const [],
    this.loading = false,
    this.error,
  });

  final List<BlobberModel> items;
  final bool loading;
  final String? error;

  BlobbersState copyWith({
    List<BlobberModel>? items,
    bool? loading,
    String? error,
  }) => BlobbersState(
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: error,
  );

  @override
  List<Object?> get props => [items, loading, error];
}

class BlobbersCubit extends Cubit<BlobbersState> with XSafeEmitMixin {
  BlobbersCubit() : super(const BlobbersState());

  Future<void> load() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final r = await BlobbersRepo.list();
    xSafeEmit(
      state.copyWith(
        loading: false,
        items: r.data?.items ?? const [],
        error: r.error?.message,
      ),
    );
  }
}
