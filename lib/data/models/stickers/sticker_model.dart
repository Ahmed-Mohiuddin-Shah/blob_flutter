import 'package:json_annotation/json_annotation.dart';

part 'sticker_model.g.dart';

@JsonSerializable()
class StickerModel {
  const StickerModel({
    required this.id,
    this.title,
    this.slug,
    this.description,
    this.status,
    this.chatUrl,
    this.thumbnailUrl,
    this.imageUrl,
    this.username,
  });

  final String id;
  final String? title;
  final String? slug;
  final String? description;
  final String? status;
  final String? chatUrl;
  final String? thumbnailUrl;
  final String? imageUrl;
  final String? username;

  String get displayTitle => title?.isNotEmpty == true ? title! : (slug ?? id);

  String? get previewUrl {
    for (final u in [thumbnailUrl, chatUrl, imageUrl]) {
      if (u != null && u.isNotEmpty) return u;
    }
    return null;
  }

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = '${json['id']}';
    // List cards use thumbUrl; detail uses media[].
    mapped['thumbnailUrl'] ??=
        json['thumbUrl'] ?? json['thumbnailUrl'] ?? json['thumbnail'];
    mapped['chatUrl'] ??= json['chatUrl'] ?? json['chat'];
    mapped['imageUrl'] ??= json['imageUrl'] ?? json['image'];

    final media = json['media'];
    if (media is List) {
      for (final item in media) {
        if (item is! Map) continue;
        final m = Map<String, dynamic>.from(item);
        final kind = '${m['kind'] ?? ''}';
        final url = m['url'] as String?;
        if (url == null || url.isEmpty) continue;
        switch (kind) {
          case 'chat':
            mapped['chatUrl'] ??= url;
          case 'thumbnail':
          case 'gif':
            mapped['thumbnailUrl'] ??= url;
          case 'image':
            mapped['imageUrl'] ??= url;
        }
      }
    } else if (media is Map) {
      mapped['chatUrl'] ??= media['chat']?['url'] ?? media['chatUrl'];
      mapped['thumbnailUrl'] ??=
          media['thumbnail']?['url'] ?? media['thumbnailUrl'];
      mapped['imageUrl'] ??= media['image']?['url'] ?? media['imageUrl'];
    }
    return _$StickerModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$StickerModelToJson(this);
}
