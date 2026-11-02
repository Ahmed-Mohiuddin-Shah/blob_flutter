import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/data/local/app_database.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatsappExportState extends Equatable {
  const WhatsappExportState({
    this.drafts = const [],
    this.busy = false,
    this.error,
  });

  final List<WhatsappPackDraft> drafts;
  final bool busy;
  final String? error;

  WhatsappExportState copyWith({
    List<WhatsappPackDraft>? drafts,
    bool? busy,
    String? error,
  }) =>
      WhatsappExportState(
        drafts: drafts ?? this.drafts,
        busy: busy ?? this.busy,
        error: error,
      );

  @override
  List<Object?> get props => [drafts, busy, error];
}

/// Stub: list/create Drift pack drafts. Encode + exporter come next.
class WhatsappExportCubit extends Cubit<WhatsappExportState>
    with XSafeEmitMixin {
  WhatsappExportCubit(this._db) : super(const WhatsappExportState());

  final AppDatabase _db;

  Future<void> loadDrafts() async {
    xSafeEmit(state.copyWith(busy: true, error: null));
    try {
      final rows = await _db.select(_db.whatsappPackDrafts).get();
      xSafeEmit(state.copyWith(busy: false, drafts: rows));
    } catch (e) {
      xSafeEmit(state.copyWith(busy: false, error: e.toString()));
    }
  }

  Future<int> createDraft({
    required String identifier,
    required String name,
    required String publisher,
  }) async {
    final id = await _db
        .into(_db.whatsappPackDrafts)
        .insert(
          WhatsappPackDraftsCompanion.insert(
            identifier: identifier,
            name: name,
            publisher: publisher,
          ),
        );
    await loadDrafts();
    return id;
  }
}
