import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/stickers/stickers_repo.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StickerEditState extends Equatable {
  const StickerEditState({
    this.sticker,
    this.loading = true,
    this.busy = false,
    this.error,
  });

  final StickerModel? sticker;
  final bool loading;
  final bool busy;
  final String? error;

  StickerEditState copyWith({
    StickerModel? sticker,
    bool? loading,
    bool? busy,
    String? error,
  }) => StickerEditState(
    sticker: sticker ?? this.sticker,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error,
  );

  @override
  List<Object?> get props => [sticker, loading, busy, error];
}

class StickerEditCubit extends Cubit<StickerEditState> with XSafeEmitMixin {
  StickerEditCubit(this.idOrSlug) : super(const StickerEditState());

  final String idOrSlug;

  Future<void> load() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final r = await StickersRepo.getByIdOrSlug(idOrSlug);
    xSafeEmit(
      state.copyWith(loading: false, sticker: r.data, error: r.error?.message),
    );
  }

  Future<StickerModel?> save({String? title, String? description}) async {
    final id = state.sticker?.id;
    if (id == null) return null;
    xSafeEmit(state.copyWith(busy: true, error: null));
    final r = await StickersRepo.patchMetadata(
      id,
      title: title,
      description: description,
    );
    xSafeEmit(
      state.copyWith(
        busy: false,
        sticker: r.data ?? state.sticker,
        error: r.error?.message,
      ),
    );
    return r.data;
  }
}
