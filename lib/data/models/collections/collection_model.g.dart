// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) =>
    CollectionModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      itemCount: (json['itemCount'] as num?)?.toInt(),
      coverUrl: json['coverUrl'] as String?,
    );

Map<String, dynamic> _$CollectionModelToJson(CollectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'itemCount': instance.itemCount,
      'coverUrl': instance.coverUrl,
    };
