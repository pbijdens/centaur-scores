// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_button_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreButtonDefinition _$ScoreButtonDefinitionFromJson(
        Map<String, dynamic> json) =>
    ScoreButtonDefinition()
      ..id = json['id'] as int
      ..label = json['label'] as String
      ..value = json['value'] as int?;

Map<String, dynamic> _$ScoreButtonDefinitionToJson(
        ScoreButtonDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'value': instance.value,
    };
