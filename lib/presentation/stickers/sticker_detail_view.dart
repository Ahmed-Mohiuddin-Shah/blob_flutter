import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/stickers/sticker_detail_cubit.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:blob_flutter/presentation/widgets/sticker_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StickerDetailView extends StatelessWidget {
  const StickerDetailView({super.key, required this.idOrSlug});

  final String idOrSlug;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickerDetailCubit(idOrSlug)..load(),
      child: BlocBuilder<StickerDetailCubit, StickerDetailState>(
        builder: (context, state) {
          final s = state.sticker;
          return BlobScaffold(
            title: s?.displayTitle.toLowerCase() ?? 'sticker',
            showSettings: false,
            slivers: [
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (s == null)
                SliverFillRemaining(
                  child: Center(child: Text(state.error ?? 'Not found')),
                )
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: s.previewUrl == null
                          ? const ColoredBox(color: Color(0x11000000))
                          : CachedNetworkImage(
                              imageUrl: s.previewUrl!,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                if (s.description != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(s.description!),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        BusyButton(
                          label: 'Favourite',
                          busy: state.busy,
                          onPressed: () => context
                              .read<StickerDetailCubit>()
                              .toggleFavourite(),
                        ),
                        BusyButton(
                          label: 'Remix',
                          onPressed: () => context.push(
                            RouteNames.stickerRemix.replaceFirst(
                              ':slug',
                              idOrSlug,
                            ),
                          ),
                        ),
                        BusyButton(
                          label: 'Compose',
                          onPressed: () => context.push(
                            RouteNames.stickerCompose.replaceFirst(
                              ':slug',
                              idOrSlug,
                            ),
                          ),
                        ),
                        BusyButton(
                          label: 'Edit',
                          onPressed: () => context.push(
                            RouteNames.stickerEdit.replaceFirst(
                              ':slug',
                              idOrSlug,
                            ),
                          ),
                        ),
                        BusyButton(
                          label: 'Claim',
                          busy: state.busy,
                          onPressed: () =>
                              context.read<StickerDetailCubit>().claim(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.similar.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: SectionHeader(eyebrow: 'More', title: 'similar'),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 160,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      delegate: SliverChildBuilderDelegate((context, i) {
                        final item = state.similar[i];
                        return StickerCard(
                          title: item.displayTitle,
                          imageUrl: item.previewUrl,
                          onTap: () => context.push(
                            RouteNames.sticker(item.id),
                          ),
                        );
                      }, childCount: state.similar.length),
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}
