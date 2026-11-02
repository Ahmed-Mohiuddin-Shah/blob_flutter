import 'package:blob_flutter/configs/remote/api/collections/collections_repo.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/collections/collections_cubit.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CollectionsView extends StatelessWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CollectionsCubit()..load(),
      child: BlocBuilder<CollectionsCubit, CollectionsState>(
        builder: (context, state) {
          return BlobScaffold(
            title: 'collections',
            actions: [
              IconButton(
                tooltip: 'New',
                onPressed: () => context.push(RouteNames.collectionsNew),
                icon: const Icon(Icons.add),
              ),
            ],
            slivers: [
              const SliverToBoxAdapter(
                child: SectionHeader(eyebrow: 'Curated', title: 'collections'),
              ),
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverList.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, i) {
                    final c = state.items[i];
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      title: Text(c.displayTitle),
                      subtitle: Text('${c.itemCount ?? 0} stickers'),
                      onTap: () => context.push(
                        RouteNames.collection(c.slug ?? c.id),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class CollectionCreateView extends StatelessWidget {
  const CollectionCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: 'new collection',
      child: _CollectionCreateBody(),
    );
  }
}

class _CollectionCreateBody extends StatefulWidget {
  @override
  State<_CollectionCreateBody> createState() => _CollectionCreateBodyState();
}

// ponytail: TextEditingController ownership only.
class _CollectionCreateBodyState extends State<_CollectionCreateBody> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CollectionsCubit(),
      child: BlocBuilder<CollectionsCubit, CollectionsState>(
        builder: (context, state) {
          return BlobScaffold(
            title: 'new collection',
            showSettings: false,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration:
                            const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 16),
                      BusyButton(
                        label: 'Create',
                        busy: state.busy,
                        onPressed: () async {
                          final created = await context
                              .read<CollectionsCubit>()
                              .create(controller.text.trim());
                          if (created != null && context.mounted) {
                            context.go(
                              RouteNames.collection(
                                created.slug ?? created.id,
                              ),
                            );
                          }
                        },
                      ),
                    ],
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

class CollectionDetailView extends StatelessWidget {
  const CollectionDetailView({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CollectionsRepo.get(slug),
      builder: (context, snap) {
        final c = snap.data?.data;
        return BlobScaffold(
          title: c?.displayTitle.toLowerCase() ?? slug,
          showSettings: false,
          actions: [
            IconButton(
              tooltip: 'Edit items',
              onPressed: () {},
              icon: const Icon(Icons.playlist_add),
            ),
          ],
          slivers: [
            if (!snap.hasData)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${c?.itemCount ?? 0} stickers (1–60)'),
                      if (c?.description != null) Text(c!.description!),
                      const SizedBox(height: 16),
                      BusyButton(
                        label: 'Make pack',
                        onPressed: () => CollectionsRepo.toPack(slug),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
