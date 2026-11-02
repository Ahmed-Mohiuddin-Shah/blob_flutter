// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SheetModel _$SheetModelFromJson(Map<String, dynamic> json) => SheetModel(
  id: json['id'] as String,
  title: json['title'] as String?,
  slug: json['slug'] as String?,
  status: json['status'] as String?,
  previewUrl: json['previewUrl'] as String?,
);

Map<String, dynamic> _$SheetModelToJson(SheetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'status': instance.status,
      'previewUrl': instance.previewUrl,
    };

PackModel _$PackModelFromJson(Map<String, dynamic> json) => PackModel(
  id: json['id'] as String,
  title: json['title'] as String?,
  slug: json['slug'] as String?,
  status: json['status'] as String?,
  previewUrl: json['previewUrl'] as String?,
);

Map<String, dynamic> _$PackModelToJson(PackModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'status': instance.status,
  'previewUrl': instance.previewUrl,
};
