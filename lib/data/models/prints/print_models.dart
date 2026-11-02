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

  factory SheetModel.fromJson(Map<String, dynamic> json) =>
      _$SheetModelFromJson(json);

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

  factory PackModel.fromJson(Map<String, dynamic> json) =>
      _$PackModelFromJson(json);

  Map<String, dynamic> toJson() => _$PackModelToJson(this);
}
