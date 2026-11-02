import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/stickers/stickers_repo.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StickersState extends Equatable {
  const StickersState({
    this.items = const [],
    this.nextCursor,
    this.loading = false,
    this.loadingMore = false,
    this.error,
  });

  final List<StickerModel> items;
  final String? nextCursor;
  final bool loading;
  final bool loadingMore;
  final String? error;

  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;

  StickersState copyWith({
    List<StickerModel>? items,
    String? nextCursor,
    bool? loading,
    bool? loadingMore,
    String? error,
    bool clearCursor = false,
  }) => StickersState(
    items: items ?? this.items,
    nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
    loading: loading ?? this.loading,
    loadingMore: loadingMore ?? this.loadingMore,
    error: error,
  );

  @override
  List<Object?> get props => [items, nextCursor, loading, loadingMore, error];
}

class StickersCubit extends Cubit<StickersState> with XSafeEmitMixin {
  StickersCubit({this.mine = false, this.status})
    : super(const StickersState());

  final bool mine;
  final String? status;
  String? _q;

  Future<void> load({String? q}) async {
    _q = q ?? _q;
    xSafeEmit(state.copyWith(loading: true, error: null, clearCursor: true));
    final result = await StickersRepo.list(q: _q, mine: mine, status: status);
    xSafeEmit(
      state.copyWith(
        loading: false,
        items: result.data?.items ?? const [],
        nextCursor: result.data?.nextCursor,
        error: result.error?.message,
        clearCursor: result.data?.nextCursor == null,
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    xSafeEmit(state.copyWith(loadingMore: true));
    final result = await StickersRepo.list(
      q: _q,
      cursor: state.nextCursor,
      mine: mine,
      status: status,
    );
    xSafeEmit(
      state.copyWith(
        loadingMore: false,
        items: [...state.items, ...?result.data?.items],
        nextCursor: result.data?.nextCursor,
        error: result.error?.message,
        clearCursor: result.data?.nextCursor == null,
      ),
    );
  }
}
