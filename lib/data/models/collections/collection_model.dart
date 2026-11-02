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

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);
}
