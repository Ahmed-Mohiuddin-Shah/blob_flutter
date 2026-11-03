import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_model.g.dart';

@JsonSerializable()
class CollectionModel {
  const CollectionModel({
    required this.id,
    this.title,
    this.slug,
    this.description,
    this.itemCount,
    this.coverUrl,
  });

  final String id;
  final String? title;
  final String? slug;
  final String? description;
  final int? itemCount;
  final String? coverUrl;

  String get displayTitle => title?.isNotEmpty == true ? title! : (slug ?? id);

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = ApiParse.asId(json['id']);
    mapped['title'] ??= ApiParse.pickString(mapped, ['name', 'title']);
    mapped['itemCount'] ??= json['stickerCount'] ?? json['itemCount'];
    final thumbs = json['previewThumbUrls'];
    if (thumbs is List && thumbs.isNotEmpty) {
      mapped['coverUrl'] ??= ApiParse.absoluteUrl(thumbs.first?.toString());
    } else {
      mapped['coverUrl'] = ApiParse.absoluteUrl(
        ApiParse.pickString(mapped, ['coverUrl', 'previewUrl']),
      );
    }
    return _$CollectionModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);
}
