import 'package:json_annotation/json_annotation.dart';

part 'blobber_model.g.dart';

@JsonSerializable()
class BlobberModel {
  const BlobberModel({
    required this.id,
    this.slug,
    this.displayName,
    this.username,
    this.bio,
  });

  final String id;
  final String? slug;
  final String? displayName;
  final String? username;
  final String? bio;

  String get displayTitle =>
      displayName?.isNotEmpty == true ? displayName! : (username ?? slug ?? id);

  factory BlobberModel.fromJson(Map<String, dynamic> json) =>
      _$BlobberModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlobberModelToJson(this);
}
