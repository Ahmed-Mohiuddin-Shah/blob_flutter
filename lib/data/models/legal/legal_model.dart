import 'package:json_annotation/json_annotation.dart';

part 'legal_model.g.dart';

@JsonSerializable()
class LegalSection {
  const LegalSection({this.heading, this.paragraphs = const []});

  final String? heading;
  final List<String> paragraphs;

  factory LegalSection.fromJson(Map<String, dynamic> json) =>
      _$LegalSectionFromJson(json);

  Map<String, dynamic> toJson() => _$LegalSectionToJson(this);
}

@JsonSerializable()
class LegalDocument {
  const LegalDocument({
    required this.slug,
    required this.title,
    this.description,
    this.updatedAt,
    this.sections = const [],
    this.tagline,
    this.lead,
  });

  final String slug;
  final String title;
  final String? description;
  final String? updatedAt;
  final List<LegalSection> sections;
  final String? tagline;
  final String? lead;

  factory LegalDocument.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$LegalDocumentToJson(this);
}
