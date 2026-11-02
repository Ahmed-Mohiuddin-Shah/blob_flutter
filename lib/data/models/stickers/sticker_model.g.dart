// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StickerModel _$StickerModelFromJson(Map<String, dynamic> json) => StickerModel(
  id: json['id'] as String,
  title: json['title'] as String?,
  slug: json['slug'] as String?,
  description: json['description'] as String?,
  status: json['status'] as String?,
  chatUrl: json['chatUrl'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  imageUrl: json['imageUrl'] as String?,
  username: json['username'] as String?,
);

Map<String, dynamic> _$StickerModelToJson(StickerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'status': instance.status,
      'chatUrl': instance.chatUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'imageUrl': instance.imageUrl,
      'username': instance.username,
    };
