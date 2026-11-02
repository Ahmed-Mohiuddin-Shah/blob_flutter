import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/collections/collections_repo.dart';
import 'package:blob_flutter/data/models/collections/collection_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsState extends Equatable {
  const CollectionsState({
    this.items = const [],
    this.nextCursor,
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final List<CollectionModel> items;
  final String? nextCursor;
  final bool loading;
  final bool busy;
  final String? error;

  CollectionsState copyWith({
    List<CollectionModel>? items,
    String? nextCursor,
    bool? loading,
    bool? busy,
    String? error,
  }) =>
      CollectionsState(
        items: items ?? this.items,
        nextCursor: nextCursor ?? this.nextCursor,
        loading: loading ?? this.loading,
        busy: busy ?? this.busy,
        error: error,
      );

  @override
  List<Object?> get props => [items, nextCursor, loading, busy, error];
}

class CollectionsCubit extends Cubit<CollectionsState> with XSafeEmitMixin {
  CollectionsCubit() : super(const CollectionsState());

  Future<void> load() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final r = await CollectionsRepo.list();
    xSafeEmit(
      state.copyWith(
        loading: false,
        items: r.data?.items ?? const [],
        nextCursor: r.data?.nextCursor,
        error: r.error?.message,
      ),
    );
  }

  Future<CollectionModel?> create(String title) async {
    xSafeEmit(state.copyWith(busy: true, error: null));
    final r = await CollectionsRepo.create(title: title);
    xSafeEmit(state.copyWith(busy: false, error: r.error?.message));
    if (r.data != null) await load();
    return r.data;
  }
}
