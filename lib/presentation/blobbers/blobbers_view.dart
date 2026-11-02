import 'package:blob_flutter/configs/remote/api/blobbers/blobbers_repo.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/blobbers/blobbers_cubit.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/blobatar.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlobbersView extends StatelessWidget {
  const BlobbersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlobbersCubit()..load(),
      child: BlocBuilder<BlobbersCubit, BlobbersState>(
        builder: (context, state) {
          return BlobScaffold(
            title: 'blobbers',
            slivers: [
              const SpiverSection(),
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverList.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, i) {
                    final b = state.items[i];
                    return ListTile(
                      leading: Blobatar(
                        username: b.username ?? b.slug ?? b.id,
                        size: 44,
                      ),
                      title: Text(b.displayTitle),
                      subtitle: Text(b.bio ?? ''),
                      onTap: () =>
                          context.push(RouteNames.blobber(b.slug ?? b.id)),
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

class SpiverSection extends StatelessWidget {
  const SpiverSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SectionHeader(eyebrow: 'People', title: 'blobbers'),
    );
  }
}

class BlobberDetailView extends StatelessWidget {
  const BlobberDetailView({super.key, required this.idOrSlug});

  final String idOrSlug;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BlobbersRepo.get(idOrSlug),
      builder: (context, snap) {
        final b = snap.data?.data;
        return BlobScaffold(
          title: b?.displayTitle.toLowerCase() ?? 'blobber',
          showSettings: false,
          slivers: [
            if (!snap.hasData)
              const SpiverLoader()
            else if (b == null)
              SliverFillRemaining(
                child: Center(
                  child: Text(snap.data?.error?.message ?? 'Missing'),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Blobatar(
                        username: b.username ?? b.slug ?? b.id,
                        size: 96,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        b.displayTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (b.bio != null) Text(b.bio!),
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

class SpiverLoader extends StatelessWidget {
  const SpiverLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class BlobberCmsView extends StatelessWidget {
  const BlobberCmsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthGate(title: 'blobber cms', child: _BlobberCmsBody());
  }
}

class _BlobberCmsBody extends StatefulWidget {
  const _BlobberCmsBody();

  @override
  State<_BlobberCmsBody> createState() => _BlobberCmsBodyState();
}

// ponytail: TextEditingController ownership only.
class _BlobberCmsBodyState extends State<_BlobberCmsBody> {
  final bio = TextEditingController();

  @override
  void dispose() {
    bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlobScaffold(
      title: 'blobber cms',
      showSettings: false,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: bio,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                BusyButton(
                  label: 'Save',
                  onPressed: () => BlobbersRepo.patchMe(bio: bio.text.trim()),
                ),
                const SizedBox(height: 12),
                BusyButton(
                  label: 'Request association',
                  onPressed: () =>
                      context.push(RouteNames.profileBlobberAssociate),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BlobberAssociateView extends StatelessWidget {
  const BlobberAssociateView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: 'associate',
      child: BlobScaffold(
        title: 'associate',
        showSettings: false,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BusyButton(
                label: 'Submit request',
                onPressed: () async {
                  await BlobbersRepo.requestAssociation();
                  if (context.mounted) context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
