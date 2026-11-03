import 'package:blob_flutter/configs/remote/api/api_parse.dart';
import 'package:json_annotation/json_annotation.dart';

part 'print_models.g.dart';

@JsonSerializable()
class SheetModel {
  const SheetModel({
    required this.id,
    this.title,
    this.slug,
    this.status,
    this.previewUrl,
  });

  final String id;
  final String? title;
  final String? slug;
  final String? status;
  final String? previewUrl;

  String get displayTitle => title?.isNotEmpty == true ? title! : (slug ?? id);

  factory SheetModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = ApiParse.asId(json['id']);
    mapped['title'] ??= ApiParse.pickString(mapped, ['name', 'title']);
    mapped['previewUrl'] = ApiParse.absoluteUrl(
      ApiParse.pickString(mapped, ['previewUrl', 'thumbUrl']),
    );
    return _$SheetModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$SheetModelToJson(this);
}

@JsonSerializable()
class PackModel {
  const PackModel({
    required this.id,
    this.title,
    this.slug,
    this.status,
    this.previewUrl,
  });

  final String id;
  final String? title;
  final String? slug;
  final String? status;
  final String? previewUrl;

  String get displayTitle => title?.isNotEmpty == true ? title! : (slug ?? id);

  factory PackModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = ApiParse.asId(json['id']);
    mapped['title'] ??= ApiParse.pickString(mapped, ['name', 'title']);
    mapped['previewUrl'] = ApiParse.absoluteUrl(
      ApiParse.pickString(mapped, ['previewUrl', 'thumbUrl']),
    );
    return _$PackModelFromJson(mapped);
  }

  Map<String, dynamic> toJson() => _$PackModelToJson(this);
}
