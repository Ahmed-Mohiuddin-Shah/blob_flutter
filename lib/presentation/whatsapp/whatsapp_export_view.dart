import 'package:blob_flutter/data/local/app_database.dart';
import 'package:blob_flutter/logic/whatsapp_export/whatsapp_export_cubit.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:blob_flutter/presentation/widgets/sticker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhatsappExportView extends StatelessWidget {
  const WhatsappExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: 'whatsapp',
      child: BlocProvider(
        create: (_) => WhatsappExportCubit(appDatabase)..load(),
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhatsappExportCubit, WhatsappExportState>(
      builder: (context, state) {
        return BlobScaffold(
          title: 'whatsapp pack',
          showSettings: false,
          slivers: [
            const SliverToBoxAdapter(
              child: SectionHeader(
                eyebrow: 'Export',
                title: 'static pack',
              ),
            ),
            if (state.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(state.error!),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final s = state.candidates[i];
                    final on = state.selected.contains(s.id);
                    return Stack(
                      children: [
                        StickerCard(
                          title: s.displayTitle,
                          imageUrl: s.previewUrl,
                          onTap: () =>
                              context.read<WhatsappExportCubit>().toggle(s.id),
                        ),
                        if (on)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(Icons.check_circle, color: Colors.green),
                          ),
                      ],
                    );
                  },
                  childCount: state.candidates.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BusyButton(
                  label: 'Build & send to WhatsApp',
                  busy: state.busy,
                  onPressed: () => context.read<WhatsappExportCubit>().exportPack(
                        identifier: 'blob_${DateTime.now().millisecondsSinceEpoch}',
                        name: 'BLOB Pack',
                        publisher: 'BLOB',
                      ),
                ),
              ),
            ),
            // ponytail: animated WhatsApp packs deferred — UI stub.
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Animated packs: TODO (v1 static only)'),
              ),
            ),
          ],
        );
      },
    );
  }
}
