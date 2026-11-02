import 'package:blob_editor/blob_editor.dart';
import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/api_error.dart';
import 'package:blob_flutter/configs/remote/api/composition/composition_repo.dart';
import 'package:blob_flutter/configs/remote/api/stickers/stickers_repo.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum EditorMode { create, compose, remix }

class EditorHostState extends Equatable {
  const EditorHostState({
    this.sticker,
    this.document,
    this.loading = false,
    this.saving = false,
    this.polling = false,
    this.error,
    this.readySticker,
  });

  final StickerModel? sticker;
  final Map<String, dynamic>? document;
  final bool loading;
  final bool saving;
  final bool polling;
  final String? error;
  final StickerModel? readySticker;

  EditorHostState copyWith({
    StickerModel? sticker,
    Map<String, dynamic>? document,
    bool? loading,
    bool? saving,
    bool? polling,
    String? error,
    StickerModel? readySticker,
  }) => EditorHostState(
    sticker: sticker ?? this.sticker,
    document: document ?? this.document,
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    polling: polling ?? this.polling,
    error: error,
    readySticker: readySticker ?? this.readySticker,
  );

  @override
  List<Object?> get props => [
    sticker,
    document,
    loading,
    saving,
    polling,
    error,
    readySticker,
  ];
}

class EditorCubit extends Cubit<EditorHostState> with XSafeEmitMixin {
  EditorCubit({required this.idOrSlug, required this.mode})
    : super(const EditorHostState());

  final String idOrSlug;
  final EditorMode mode;

  Future<void> prepare() async {
    if (mode == EditorMode.create) {
      xSafeEmit(state.copyWith(loading: false));
      return;
    }
    xSafeEmit(state.copyWith(loading: true, error: null));
    var targetId = idOrSlug;
    if (mode == EditorMode.remix) {
      final remixed = await CompositionRepo.remix(idOrSlug);
      if (remixed.error != null || remixed.data == null) {
        xSafeEmit(
          state.copyWith(
            loading: false,
            error: remixed.error?.message ?? 'Remix failed',
          ),
        );
        return;
      }
      targetId = remixed.data!.id;
    }
    final r = await StickersRepo.getByIdOrSlug(targetId);
    xSafeEmit(
      state.copyWith(loading: false, sticker: r.data, error: r.error?.message),
    );
  }

  Future<StickerModel?> export(ExportPayload payload) async {
    xSafeEmit(state.copyWith(saving: true, error: null));
    final doc = payload.document.toJson();
    late final ({StickerModel? data, ApiError? error}) saved;
    if (mode == EditorMode.create || state.sticker == null) {
      saved = await CompositionRepo.create(
        document: doc,
        chat: payload.chat,
        thumbnail: payload.thumbnail,
        full: payload.full,
        mask: payload.mask,
      );
    } else {
      saved = await CompositionRepo.saveComposition(
        state.sticker!.id,
        document: doc,
        chat: payload.chat,
        thumbnail: payload.thumbnail,
        full: payload.full,
        mask: payload.mask,
      );
    }
    if (saved.data == null) {
      xSafeEmit(
        state.copyWith(
          saving: false,
          error: saved.error?.message ?? 'Save failed',
        ),
      );
      return null;
    }
    xSafeEmit(
      state.copyWith(saving: false, polling: true, sticker: saved.data),
    );
    final polled = await CompositionRepo.pollUntilReady(saved.data!.id);
    xSafeEmit(
      state.copyWith(
        polling: false,
        readySticker: polled.data ?? saved.data,
        error: polled.error?.message,
      ),
    );
    return polled.data ?? saved.data;
  }
}
