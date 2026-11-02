import 'package:blob_flutter/configs/remote/api/legal/legal_repo.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LegalRepo.get(slug),
      builder: (context, snap) {
        final doc = snap.data?.data;
        return BlobScaffold(
          title: doc?.title.toLowerCase() ?? slug,
          showSettings: false,
          slivers: [
            if (!snap.hasData)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (doc == null)
              SpiverError(message: snap.data?.error?.message ?? 'Missing')
            else ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  eyebrow: doc.slug,
                  title: doc.title.toLowerCase(),
                ),
              ),
              if (doc.lead != null || doc.description != null)
                SpiverParagraph(doc.lead ?? doc.description ?? ''),
              for (final section in doc.sections) ...[
                if (section.heading != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        section.heading!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                for (final p in section.paragraphs) SpiverParagraph(p),
              ],
            ],
          ],
        );
      },
    );
  }
}

class SpiverParagraph extends StatelessWidget {
  const SpiverParagraph(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Text(text),
      ),
    );
  }
}

class SpiverError extends StatelessWidget {
  const SpiverError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(child: Center(child: Text(message)));
  }
}
