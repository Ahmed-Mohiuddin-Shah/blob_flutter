import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Blobatar from username — never Zitadel picture URLs.
class Blobatar extends StatelessWidget {
  const Blobatar({super.key, required this.username, this.size = 72});

  final String username;
  final double size;

  String get _url {
    final u = Uri.encodeComponent(username.isEmpty ? 'blob' : username);
    return 'https://api.blobatar.dev/avatar/$u.svg?size=${size.round()}';
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: _url,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => CircleAvatar(
            radius: size / 2,
            child: Text(
              username.isEmpty ? '?' : username[0].toUpperCase(),
            ),
          ),
        ),
      ),
    );
  }
}
