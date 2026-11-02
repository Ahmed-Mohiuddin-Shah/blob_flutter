import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:blob_flutter/configs/remote/api/me/me_repo.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';
import 'package:blob_flutter/logic/me/me_cubit.dart';
import 'package:blob_flutter/logic/stickers/stickers_cubit.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/blobatar.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:blob_flutter/presentation/widgets/sticker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, auth) {
        if (auth.status != AuthStatus.signedIn) {
          return BlobScaffold(
            title: 'profile',
            showSettings: false,
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: BusyButton(
                    label: 'Sign in',
                    busy: auth.busy,
                    onPressed: () async {
                      final ok = await context.read<AuthCubit>().signIn();
                      if (ok) await AppGlobals.meCubit.load();
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return BlocBuilder<MeCubit, MeState>(
          bloc: AppGlobals.meCubit,
          builder: (context, me) {
            final u = me.me?.username ?? 'member';
            return BlobScaffold(
              title: 'profile',
              showSettings: false,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Blobatar(username: u, size: 96),
                        const SizedBox(height: 12),
                        Text(
                          '@$u',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${me.me?.role ?? ''} · ${me.me?.accountStatus ?? ''}',
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (final e in [
                              ('Favourites', RouteNames.favourites),
                              ('Uploads', RouteNames.uploads),
                              ('Prints', RouteNames.profilePrints),
                              ('Blobber', RouteNames.profileBlobber),
                              ('Settings', RouteNames.settings),
                              ('Upload new', RouteNames.upload),
                              ('WhatsApp', '/whatsapp-export'),
                            ])
                              TextButton(
                                onPressed: () => context.push(e.$2),
                                child: Text(e.$1),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _UsernameEditor(
                          initial: u,
                          busy: me.loading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _UsernameEditor extends StatefulWidget {
  const _UsernameEditor({required this.initial, required this.busy});

  final String initial;
  final bool busy;

  @override
  State<_UsernameEditor> createState() => _UsernameEditorState();
}

// ponytail: TextEditingController ownership only.
class _UsernameEditorState extends State<_UsernameEditor> {
  late final TextEditingController _c =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _c,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        const SizedBox(height: 8),
        BusyButton(
          label: 'Save username',
          busy: widget.busy,
          onPressed: () async {
            await MeRepo.patchUsername(_c.text.trim());
            await AppGlobals.meCubit.load();
          },
        ),
      ],
    );
  }
}

class LibraryView extends StatelessWidget {
  const LibraryView({super.key, this.status, this.title = 'uploads'});

  final String? status;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickersCubit(mine: true, status: status)..load(),
      child: BlocBuilder<StickersCubit, StickersState>(
        builder: (context, state) {
          return BlobScaffold(
            title: title,
            showSettings: false,
            slivers: [
              const SliverToBoxAdapter(
                child: SectionHeader(eyebrow: 'Library', title: 'yours'),
              ),
              if (state.loading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final s = state.items[i];
                        return StickerCard(
                          title: s.displayTitle,
                          imageUrl: s.previewUrl,
                          onTap: () => context.push(
                            RouteNames.sticker(s.slug ?? s.id),
                          ),
                        );
                      },
                      childCount: state.items.length,
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
