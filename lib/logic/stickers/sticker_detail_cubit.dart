import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/favourites/favourites_repo.dart';
import 'package:blob_flutter/configs/remote/api/stickers/stickers_repo.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StickerDetailState extends Equatable {
  const StickerDetailState({
    this.sticker,
    this.similar = const [],
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final StickerModel? sticker;
  final List<StickerModel> similar;
  final bool loading;
  final bool busy;
  final String? error;

  StickerDetailState copyWith({
    StickerModel? sticker,
    List<StickerModel>? similar,
    bool? loading,
    bool? busy,
    String? error,
  }) =>
      StickerDetailState(
        sticker: sticker ?? this.sticker,
        similar: similar ?? this.similar,
        loading: loading ?? this.loading,
        busy: busy ?? this.busy,
        error: error,
      );

  @override
  List<Object?> get props => [sticker, similar, loading, busy, error];
}

class StickerDetailCubit extends Cubit<StickerDetailState>
    with XSafeEmitMixin {
  StickerDetailCubit(this.idOrSlug) : super(const StickerDetailState());

  final String idOrSlug;

  Future<void> load() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final result = await StickersRepo.getByIdOrSlug(idOrSlug);
    List<StickerModel> similar = const [];
    if (result.data != null) {
      final sim = await StickersRepo.similar(result.data!.id);
      similar = sim.data?.items ?? const [];
    }
    xSafeEmit(
      state.copyWith(
        loading: false,
        sticker: result.data,
        similar: similar,
        error: result.error?.message,
      ),
    );
  }

  Future<void> toggleFavourite() async {
    final s = state.sticker;
    if (s == null) return;
    xSafeEmit(state.copyWith(busy: true));
    await FavouritesRepo.put(subjectType: 'sticker', subjectId: s.id);
    xSafeEmit(state.copyWith(busy: false));
  }

  Future<void> claim() async {
    final s = state.sticker;
    if (s == null) return;
    xSafeEmit(state.copyWith(busy: true, error: null));
    final r = await StickersRepo.createAttributionClaim(s.id);
    xSafeEmit(state.copyWith(busy: false, error: r.error?.message));
  }
}
