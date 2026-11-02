import 'package:blob_flutter/configs/app/extensions/x_safe_cubit_mixin.dart';
import 'package:blob_flutter/configs/remote/api/prints/prints_repo.dart';
import 'package:blob_flutter/data/models/prints/print_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrintsState extends Equatable {
  const PrintsState({
    this.sheets = const [],
    this.packs = const [],
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final List<SheetModel> sheets;
  final List<PackModel> packs;
  final bool loading;
  final bool busy;
  final String? error;

  PrintsState copyWith({
    List<SheetModel>? sheets,
    List<PackModel>? packs,
    bool? loading,
    bool? busy,
    String? error,
  }) => PrintsState(
    sheets: sheets ?? this.sheets,
    packs: packs ?? this.packs,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error,
  );

  @override
  List<Object?> get props => [sheets, packs, loading, busy, error];
}

class PrintsCubit extends Cubit<PrintsState> with XSafeEmitMixin {
  PrintsCubit() : super(const PrintsState());

  Future<void> load() async {
    xSafeEmit(state.copyWith(loading: true, error: null));
    final sheets = await PrintsRepo.listSheets();
    final packs = await PrintsRepo.listPacks();
    xSafeEmit(
      state.copyWith(
        loading: false,
        sheets: sheets.data?.items ?? const [],
        packs: packs.data?.items ?? const [],
        error: sheets.error?.message ?? packs.error?.message,
      ),
    );
  }

  Future<SheetModel?> createSheet(String title) async {
    xSafeEmit(state.copyWith(busy: true));
    final r = await PrintsRepo.createSheet(title: title);
    xSafeEmit(state.copyWith(busy: false, error: r.error?.message));
    if (r.data != null) await load();
    return r.data;
  }

  Future<PackModel?> createPack(String title) async {
    xSafeEmit(state.copyWith(busy: true));
    final r = await PrintsRepo.createPack(title: title);
    xSafeEmit(state.copyWith(busy: false, error: r.error?.message));
    if (r.data != null) await load();
    return r.data;
  }
}
