// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blobber_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlobberModel _$BlobberModelFromJson(Map<String, dynamic> json) => BlobberModel(
  id: json['id'] as String,
  slug: json['slug'] as String?,
  displayName: json['displayName'] as String?,
  username: json['username'] as String?,
  bio: json['bio'] as String?,
);

Map<String, dynamic> _$BlobberModelToJson(BlobberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'displayName': instance.displayName,
      'username': instance.username,
      'bio': instance.bio,
    };
