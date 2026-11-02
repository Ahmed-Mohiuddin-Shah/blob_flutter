import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/search/search_cubit.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:blob_flutter/presentation/widgets/sticker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final c = SearchCubit(initialQuery: initialQuery);
        if (initialQuery != null && initialQuery!.isNotEmpty) {
          c.search(initialQuery!);
        }
        return c;
      },
      child: const _SearchBody(),
    );
  }
}

class _SearchBody extends StatefulWidget {
  const _SearchBody();

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

// ponytail: TextEditingController needs a State; query still owned by Cubit.
class _SearchBodyState extends State<_SearchBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<SearchCubit>().state.query,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return BlobScaffold(
          title: 'search',
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search stickers…',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () =>
                          context.read<SearchCubit>().search(_controller.text),
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => context.read<SearchCubit>().search(v),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SectionHeader(eyebrow: 'Results', title: 'matches'),
            ),
            if (state.loading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && state.items.isEmpty)
              SliverFillRemaining(child: Center(child: Text(state.error!)))
            else
              SpiverSearchGrid(state: state),
          ],
        );
      },
    );
  }
}

class SpiverSearchGrid extends StatelessWidget {
  const SpiverSearchGrid({super.key, required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          childAspectRatio: 0.78,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, i) {
          final s = state.items[i];
          return StickerCard(
            title: s.displayTitle,
            imageUrl: s.previewUrl,
            onTap: () => context.push(RouteNames.sticker(s.slug ?? s.id)),
          );
        }, childCount: state.items.length),
      ),
    );
  }
}
