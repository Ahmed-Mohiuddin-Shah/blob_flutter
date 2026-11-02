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
  final String? appGroup;

  factory MeModel.fromJson(Map<String, dynamic> json) =>
      _$MeModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeModelToJson(this);
}
