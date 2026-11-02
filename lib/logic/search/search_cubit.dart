import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/search/search_repo.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.items = const [],
    this.loading = false,
    this.error,
  });

  final String query;
  final List<StickerModel> items;
  final bool loading;
  final String? error;

  SearchState copyWith({
    String? query,
    List<StickerModel>? items,
    bool? loading,
    String? error,
  }) => SearchState(
    query: query ?? this.query,
    items: items ?? this.items,
    loading: loading ?? this.loading,
    error: error,
  );

  @override
  List<Object?> get props => [query, items, loading, error];
}

class SearchCubit extends Cubit<SearchState> with XSafeEmitMixin {
  SearchCubit({String? initialQuery})
    : super(SearchState(query: initialQuery ?? ''));

  Future<void> search(String q) async {
    xSafeEmit(state.copyWith(query: q, loading: true, error: null));
    if (q.trim().isEmpty) {
      xSafeEmit(state.copyWith(loading: false, items: const []));
      return;
    }
    final r = await SearchRepo.search(q: q.trim());
    xSafeEmit(
      state.copyWith(
        loading: false,
        items: r.data?.items ?? const [],
        error: r.error?.message,
      ),
    );
  }
}
