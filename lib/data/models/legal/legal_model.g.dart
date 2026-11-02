// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalSection _$LegalSectionFromJson(Map<String, dynamic> json) => LegalSection(
  heading: json['heading'] as String?,
  paragraphs:
      (json['paragraphs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$LegalSectionToJson(LegalSection instance) =>
    <String, dynamic>{
      'heading': instance.heading,
      'paragraphs': instance.paragraphs,
    };

LegalDocument _$LegalDocumentFromJson(Map<String, dynamic> json) =>
    LegalDocument(
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      updatedAt: json['updatedAt'] as String?,
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map((e) => LegalSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tagline: json['tagline'] as String?,
      lead: json['lead'] as String?,
    );

Map<String, dynamic> _$LegalDocumentToJson(LegalDocument instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'updatedAt': instance.updatedAt,
      'sections': instance.sections,
      'tagline': instance.tagline,
      'lead': instance.lead,
    };
