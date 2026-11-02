import 'package:blob_editor/blob_editor.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/editor/editor_cubit.dart';
import 'package:blob_flutter/presentation/editor/keyboard_tray.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

export 'package:blob_flutter/logic/editor/editor_cubit.dart' show EditorMode;

class EditorHostView extends StatelessWidget {
  const EditorHostView({super.key, required this.idOrSlug, required this.mode});

  final String idOrSlug;
  final EditorMode mode;

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: mode.name,
      child: BlocProvider(
        create: (_) => EditorCubit(idOrSlug: idOrSlug, mode: mode)..prepare(),
        child: const _EditorBody(),
      ),
    );
  }
}

class _EditorBody extends StatelessWidget {
  const _EditorBody();

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return BlocBuilder<EditorCubit, EditorHostState>(
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.readySticker != null) {
          final s = state.readySticker!;
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                pad.top + 24,
                24,
                pad.bottom + 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ready: ${s.displayTitle}'),
                  const SizedBox(height: 16),
                  BusyButton(
                    label: 'View sticker',
                    onPressed: () =>
                        context.go(RouteNames.sticker(s.slug ?? s.id)),
                  ),
                  const SizedBox(height: 8),
                  BusyButton(
                    label: 'Print preview',
                    onPressed: () => _showPrintPreview(context),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.saving || state.polling) {
          return Scaffold(
            body: Center(
              child: Text(state.polling ? 'Processing…' : 'Saving…'),
            ),
          );
        }
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: pad.top),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const Expanded(flex: 1, child: KeyboardTray()),
              Expanded(
                flex: 5,
                child: BlobEditor(
                  document: state.document,
                  onCancel: () => context.pop(),
                  onExport: (payload) async {
                    await context.read<EditorCubit>().export(payload);
                  },
                ),
              ),
              SizedBox(height: pad.bottom),
            ],
          ),
        );
      },
    );
  }

  void _showPrintPreview(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        final pad = MediaQuery.paddingOf(ctx);
        // Minimal print layout preview — host PNG; PDF from worker when ready.
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, pad.bottom + 16),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Print preview'),
              SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 210 / 297,
                child: ColoredBox(
                  color: Color(0xFFF5F5F5),
                  child: Center(child: Text('A4 sheet preview')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
