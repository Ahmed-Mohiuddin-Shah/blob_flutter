// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeModel _$MeModelFromJson(Map<String, dynamic> json) => MeModel(
  id: json['id'] as String,
  username: json['username'] as String?,
  role: json['role'] as String?,
  accountStatus: json['account_status'] as String?,
  appGroup: json['appGroup'] as String?,
);

Map<String, dynamic> _$MeModelToJson(MeModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'role': instance.role,
  'account_status': instance.accountStatus,
  'appGroup': instance.appGroup,
};
