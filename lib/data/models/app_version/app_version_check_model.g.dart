// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionCheckModel _$AppVersionCheckModelFromJson(
  Map<String, dynamic> json,
) => AppVersionCheckModel(
  status: json['status'] as String,
  heading: json['heading'] as String?,
  message: json['message'] as String?,
  storeUrl: json['storeUrl'] as String?,
  iconUrl: json['iconUrl'] as String?,
  backgroundUrl: json['backgroundUrl'] as String?,
);

Map<String, dynamic> _$AppVersionCheckModelToJson(
  AppVersionCheckModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'heading': instance.heading,
  'message': instance.message,
  'storeUrl': instance.storeUrl,
  'iconUrl': instance.iconUrl,
  'backgroundUrl': instance.backgroundUrl,
};
