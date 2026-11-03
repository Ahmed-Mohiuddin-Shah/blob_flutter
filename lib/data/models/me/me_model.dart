import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me_model.g.dart';

@JsonSerializable()
class MeModel {
  const MeModel({
    required this.id,
    this.username,
    this.role,
    this.accountStatus,
    this.appGroup,
  });

  final String id;
  final String? username;
  final String? role;
  final String? accountStatus;
  /// App group key (live API sends `{ key, name }`).
  final String? appGroup;

  factory MeModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = ApiParse.asId(json['id']);
    final group = json['appGroup'];
    if (group is Map) {
      mapped['appGroup'] =
          ApiParse.pickString(Map<String, dynamic>.from(group), ['key', 'name']);
    } else if (group is String) {
      mapped['appGroup'] = group;
    }
    return _$MeModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$MeModelToJson(this);
}
