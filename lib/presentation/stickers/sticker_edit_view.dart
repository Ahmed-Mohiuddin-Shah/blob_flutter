import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/stickers/sticker_edit_cubit.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StickerEditView extends StatelessWidget {
  const StickerEditView({super.key, required this.idOrSlug});

  final String idOrSlug;

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: 'edit sticker',
      child: BlocProvider(
        create: (_) => StickerEditCubit(idOrSlug)..load(),
        child: _EditBody(idOrSlug: idOrSlug),
      ),
    );
  }
}

class _EditBody extends StatefulWidget {
  const _EditBody({required this.idOrSlug});

  final String idOrSlug;

  @override
  State<_EditBody> createState() => _EditBodyState();
}

// ponytail: TextEditingController ownership only; save state lives in Cubit.
class _EditBodyState extends State<_EditBody> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  var _seeded = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StickerEditCubit, StickerEditState>(
      listener: (context, state) {
        if (!_seeded && state.sticker != null) {
          _title.text = state.sticker!.title ?? '';
          _desc.text = state.sticker!.description ?? '';
          _seeded = true;
        }
      },
      builder: (context, state) {
        return BlobScaffold(
          title: 'edit',
          showSettings: false,
          slivers: [
            if (state.loading)
              const SpiverFillCenter()
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (state.error != null) Text(state.error!),
                      TextField(
                        controller: _title,
                        decoration:
                            const InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: _desc,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      BusyButton(
                        label: 'Save metadata',
                        busy: state.busy,
                        onPressed: () async {
                          final saved = await context
                              .read<StickerEditCubit>()
                              .save(
                                title: _title.text.trim(),
                                description: _desc.text.trim(),
                              );
                          if (saved != null && context.mounted) {
                            context.go(
                              RouteNames.sticker(saved.slug ?? saved.id),
                            );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () => context.push(
                          RouteNames.stickerCompose
                              .replaceFirst(':slug', widget.idOrSlug),
                        ),
                        child: const Text('Open composer'),
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

class SpiverFillCenter extends StatelessWidget {
  const SpiverFillCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
