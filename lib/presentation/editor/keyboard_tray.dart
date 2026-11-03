import 'package:blob_flutter/configs/remote/api/keyboard/keyboard_repo.dart';
import 'package:blob_flutter/data/models/stickers/sticker_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Compact chat-keyboard strip fed by `GET /api/keyboard/stickers`.
class KeyboardTray extends StatefulWidget {
  const KeyboardTray({super.key});

  @override
  State<KeyboardTray> createState() => _KeyboardTrayState();
}

class _KeyboardTrayState extends State<KeyboardTray> {
  List<StickerModel> _items = const [];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await KeyboardRepo.stickers();
    if (!mounted) return;
    setState(() {
      _items = r.data?.items ?? const [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ponytail: tray is ephemeral UI chrome; Cubit would be noise for a strip.
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (_items.isEmpty) {
      return const Center(child: Text('No tray stickers'));
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: _items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, i) {
        final s = _items[i];
        final url = s.chatUrl ?? s.previewUrl;
        return SizedBox(
          width: 56,
          height: 56,
          child: url == null
              ? const ColoredBox(color: Color(0x22000000))
              : CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
        );
      },
    );
  }
}
