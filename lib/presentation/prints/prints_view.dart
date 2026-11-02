import 'package:blob_flutter/configs/remote/api/prints/prints_repo.dart';
import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/logic/prints/prints_cubit.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintsView extends StatelessWidget {
  const PrintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrintsCubit()..load(),
      child: BlocBuilder<PrintsCubit, PrintsState>(
        builder: (context, state) {
          return BlobScaffold(
            title: 'prints',
            actions: [
              IconButton(
                tooltip: 'New sheet',
                onPressed: () => context.push(RouteNames.printsSheetsNew),
                icon: const Icon(Icons.grid_on_outlined),
              ),
              IconButton(
                tooltip: 'New pack',
                onPressed: () => context.push(RouteNames.printsPacksNew),
                icon: const Icon(Icons.collections_bookmark_outlined),
              ),
            ],
            slivers: [
              const SliverToBoxAdapter(
                child: SectionHeader(eyebrow: 'Print', title: 'sheets'),
              ),
              if (state.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: state.sheets.length,
                  itemBuilder: (context, i) {
                    final s = state.sheets[i];
                    return ListTile(
                      title: Text(s.displayTitle),
                      subtitle: Text(s.status ?? ''),
                      onTap: () =>
                          context.push(RouteNames.sheet(s.slug ?? s.id)),
                    );
                  },
                ),
              const SpiverHeaderAdapter(),
              SliverList.builder(
                itemCount: state.packs.length,
                itemBuilder: (context, i) {
                  final p = state.packs[i];
                  return ListTile(
                    title: Text(p.displayTitle),
                    subtitle: Text(p.status ?? ''),
                    onTap: () => context.push(RouteNames.pack(p.slug ?? p.id)),
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

class SpiverHeaderAdapter extends StatelessWidget {
  const SpiverHeaderAdapter({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: SectionHeader(eyebrow: 'Print', title: 'packs'),
    );
  }
}

class PrintCreateView extends StatelessWidget {
  const PrintCreateView({super.key, required this.kind});

  /// `sheet` | `pack`
  final String kind;

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: 'new $kind',
      child: _PrintCreateBody(kind: kind),
    );
  }
}

class _PrintCreateBody extends StatefulWidget {
  const _PrintCreateBody({required this.kind});

  final String kind;

  @override
  State<_PrintCreateBody> createState() => _PrintCreateBodyState();
}

// ponytail: TextEditingController ownership only.
class _PrintCreateBodyState extends State<_PrintCreateBody> {
  final c = TextEditingController();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrintsCubit(),
      child: BlocBuilder<PrintsCubit, PrintsState>(
        builder: (context, state) {
          return BlobScaffold(
            title: 'new ${widget.kind}',
            showSettings: false,
            slivers: [
              SpiverCreateForm(
                controller: c,
                busy: state.busy,
                onCreate: () async {
                  final title = c.text.trim();
                  if (widget.kind == 'sheet') {
                    final s = await context.read<PrintsCubit>().createSheet(
                      title,
                    );
                    if (s != null && context.mounted) {
                      context.go(RouteNames.sheet(s.slug ?? s.id));
                    }
                  } else {
                    final p = await context.read<PrintsCubit>().createPack(
                      title,
                    );
                    if (p != null && context.mounted) {
                      context.go(RouteNames.pack(p.slug ?? p.id));
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class SpiverCreateForm extends StatelessWidget {
  const SpiverCreateForm({
    super.key,
    required this.controller,
    required this.busy,
    required this.onCreate,
  });

  final TextEditingController controller;
  final bool busy;
  final Future<void> Function() onCreate;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            BusyButton(label: 'Create', busy: busy, onPressed: onCreate),
          ],
        ),
      ),
    );
  }
}

class PrintDetailView extends StatelessWidget {
  const PrintDetailView({super.key, required this.id, required this.isSheet});

  final String id;
  final bool isSheet;

  @override
  Widget build(BuildContext context) {
    return BlobScaffold(
      title: isSheet ? 'sheet' : 'pack',
      showSettings: false,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(id),
                const SizedBox(height: 16),
                BusyButton(
                  label: 'Open PNG',
                  onPressed: () {
                    final url = PrintsRepo.mediaUrl('png', id, sheet: isSheet);
                    launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                const SizedBox(height: 8),
                BusyButton(
                  label: 'Open PDF',
                  onPressed: () {
                    final url = PrintsRepo.mediaUrl('pdf', id, sheet: isSheet);
                    launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
