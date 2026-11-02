import 'package:json_annotation/json_annotation.dart';

part 'app_version_check_model.g.dart';

@JsonSerializable()
class AppVersionCheckModel {
  const AppVersionCheckModel({
    required this.status,
    this.heading,
    this.message,
    this.storeUrl,
    this.iconUrl,
    this.backgroundUrl,
  });

  /// `ok` | `suggest_update` | `force_update`
  final String status;
  final String? heading;
  final String? message;
  final String? storeUrl;
  final String? iconUrl;
  final String? backgroundUrl;

  factory AppVersionCheckModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionCheckModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionCheckModelToJson(this);
}
