// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantModel _$ParticipantModelFromJson(Map<String, dynamic> json) =>
    ParticipantModel()
      ..id = json['id'] as int
      ..lijn = json['lijn'] as String
      ..name = json['name'] as String?
      ..group = json['group'] as String
      ..subgroup = json['subgroup'] as String
      ..ends = (json['ends'] as List<dynamic>)
          .map((e) => EndModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..score = json['score'] as int;

Map<String, dynamic> _$ParticipantModelToJson(ParticipantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lijn': instance.lijn,
      'name': instance.name,
      'group': instance.group,
      'subgroup': instance.subgroup,
      'ends': instance.ends,
      'score': instance.score,
    };
