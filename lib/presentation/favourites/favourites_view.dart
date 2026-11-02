import 'package:blob_flutter/configs/remote/api/favourites/favourites_repo.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

class FavouritesView extends StatelessWidget {
  const FavouritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGate(
      title: 'favourites',
      child: FutureBuilder(
        future: FavouritesRepo.list(),
        builder: (context, snap) {
          final items = snap.data?.data?.items ?? const [];
          return BlobScaffold(
            title: 'favourites',
            showSettings: false,
            slivers: [
              const SliverToBoxAdapter(
                child: SectionHeader(eyebrow: 'Saved', title: 'favourites'),
              ),
              if (!snap.hasData)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverList.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final m = items[i];
                    return ListTile(
                      title: Text(
                        '${m['subjectType'] ?? m['type'] ?? 'item'}',
                      ),
                      subtitle: Text('${m['subjectId'] ?? m['id'] ?? ''}'),
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
