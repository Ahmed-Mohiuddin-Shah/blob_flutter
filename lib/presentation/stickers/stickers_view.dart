import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/stickers/stickers_cubit.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:blob_flutter/presentation/widgets/sticker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StickersView extends StatelessWidget {
  const StickersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickersCubit()..load(),
      child: BlocBuilder<StickersCubit, StickersState>(
        builder: (context, state) {
          return BlobScaffold(
            title: 'stickers',
            slivers: [
              const SliverToBoxAdapter(
                child: SectionHeader(
                  eyebrow: 'Browse',
                  title: 'stickers',
                ),
              ),
              if (state.loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && state.items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(state.error!)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        if (i == state.items.length) {
                          context.read<StickersCubit>().loadMore();
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        final s = state.items[i];
                        return StickerCard(
                          title: s.displayTitle,
                          imageUrl: s.previewUrl,
                          onTap: () => context.push(
                            RouteNames.sticker(s.slug ?? s.id),
                          ),
                        );
                      },
                      childCount:
                          state.items.length + (state.hasMore ? 1 : 0),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
