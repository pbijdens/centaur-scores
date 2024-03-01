// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndModel _$EndModelFromJson(Map<String, dynamic> json) => EndModel()
  ..arrows = (json['arrows'] as List<dynamic>).map((e) => e as int?).toList()
  ..score = json['score'] as int?;

Map<String, dynamic> _$EndModelToJson(EndModel instance) => <String, dynamic>{
      'arrows': instance.arrows,
      'score': instance.score,
    };
