import 'package:blob_flutter/configs/remote/api/api_parse.dart';
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

  factory BlobberModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = ApiParse.asId(json['id']);
    mapped['bio'] ??=
        ApiParse.pickString(mapped, ['description', 'bio']);
    mapped['displayName'] ??=
        ApiParse.pickString(mapped, ['displayName', 'name']);
    final href = json['href'] as String?;
    if (href != null && href.startsWith('/blobbers/')) {
      mapped['slug'] ??= href.split('/').where((s) => s.isNotEmpty).last;
    }
    mapped['username'] ??=
        ApiParse.pickString(mapped, ['username', 'slug']) ?? mapped['slug'];
    return _$BlobberModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$BlobberModelToJson(this);
}
