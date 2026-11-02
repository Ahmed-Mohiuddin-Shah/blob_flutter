import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/stickers/stickers_repo.dart';
import 'package:blob_flutter/data/local/app_database.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:blob_flutter/services/whatsapp_pack_builder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatsappExportState extends Equatable {
  const WhatsappExportState({
    this.drafts = const [],
    this.candidates = const [],
    this.selected = const {},
    this.busy = false,
    this.error,
  });

  final List<WhatsappPackDraft> drafts;
  final List<StickerModel> candidates;
  final Set<String> selected;
  final bool busy;
  final String? error;

  WhatsappExportState copyWith({
    List<WhatsappPackDraft>? drafts,
    List<StickerModel>? candidates,
    Set<String>? selected,
    bool? busy,
    String? error,
  }) =>
      WhatsappExportState(
        drafts: drafts ?? this.drafts,
        candidates: candidates ?? this.candidates,
        selected: selected ?? this.selected,
        busy: busy ?? this.busy,
        error: error,
      );

  @override
  List<Object?> get props => [drafts, candidates, selected, busy, error];
}

class WhatsappExportCubit extends Cubit<WhatsappExportState>
    with XSafeEmitMixin {
  WhatsappExportCubit(this._db) : super(const WhatsappExportState());

  final AppDatabase _db;

  Future<void> load() async {
    xSafeEmit(state.copyWith(busy: true, error: null));
    try {
      final rows = await _db.select(_db.whatsappPackDrafts).get();
      final stickers = await StickersRepo.list(mine: true, status: 'approved');
      xSafeEmit(
        state.copyWith(
          busy: false,
          drafts: rows,
          candidates: stickers.data?.items ?? const [],
          error: stickers.error?.message,
        ),
      );
    } catch (e) {
      xSafeEmit(state.copyWith(busy: false, error: e.toString()));
    }
  }

  void toggle(String id) {
    final next = Set<String>.from(state.selected);
    if (!next.add(id)) next.remove(id);
    xSafeEmit(state.copyWith(selected: next));
  }

  Future<void> exportPack({
    required String identifier,
    required String name,
    required String publisher,
  }) async {
    if (state.selected.isEmpty) {
      xSafeEmit(state.copyWith(error: 'Pick at least one sticker'));
      return;
    }
    xSafeEmit(state.copyWith(busy: true, error: null));
    try {
      final packId = await _db.into(_db.whatsappPackDrafts).insert(
            WhatsappPackDraftsCompanion.insert(
              identifier: identifier,
              name: name,
              publisher: publisher,
            ),
          );
      await WhatsappPackBuilder.buildAndSend(
        db: _db,
        packId: packId,
        stickerIds: state.selected.toList(),
      );
      await load();
    } catch (e) {
      xSafeEmit(state.copyWith(busy: false, error: e.toString()));
    }
  }
}
