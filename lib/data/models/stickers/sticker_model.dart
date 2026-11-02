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

  String? get previewUrl => thumbnailUrl ?? chatUrl ?? imageUrl;

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    // Defensive: API may nest media URLs.
    final mapped = Map<String, dynamic>.from(json);
    final media = json['media'];
    if (media is Map) {
      mapped['chatUrl'] ??= media['chat']?['url'] ?? media['chatUrl'];
      mapped['thumbnailUrl'] ??=
          media['thumbnail']?['url'] ?? media['thumbnailUrl'];
      mapped['imageUrl'] ??= media['image']?['url'] ?? media['imageUrl'];
    }
    return _$StickerModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$StickerModelToJson(this);
}
