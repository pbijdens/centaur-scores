// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel()
  ..isDirty = json['isDirty'] as bool
  ..id = json['id'] as int
  ..deviceID = json['deviceID'] as String
  ..matchCode = json['matchCode'] as String
  ..matchName = json['matchName'] as String
  ..numberOfEnds = json['numberOfEnds'] as int
  ..arrowsPerEnd = json['arrowsPerEnd'] as int
  ..autoProgressAfterEachArrow = json['autoProgressAfterEachArrow'] as bool
  ..scoreValues = (json['scoreValues'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
        k,
        (e as List<dynamic>)
            .map((e) =>
                ScoreButtonDefinition.fromJson(e as Map<String, dynamic>))
            .toList()),
  )
  ..groups = (json['groups'] as List<dynamic>)
      .map((e) => GroupInfo.fromJson(e as Map<String, dynamic>))
      .toList()
  ..subgroups = (json['subgroups'] as List<dynamic>)
      .map((e) => GroupInfo.fromJson(e as Map<String, dynamic>))
      .toList()
  ..targets = (json['targets'] as List<dynamic>)
      .map((e) => GroupInfo.fromJson(e as Map<String, dynamic>))
      .toList()
  ..participants = (json['participants'] as List<dynamic>)
      .map((e) => ParticipantModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'isDirty': instance.isDirty,
      'id': instance.id,
      'deviceID': instance.deviceID,
      'matchCode': instance.matchCode,
      'matchName': instance.matchName,
      'numberOfEnds': instance.numberOfEnds,
      'arrowsPerEnd': instance.arrowsPerEnd,
      'autoProgressAfterEachArrow': instance.autoProgressAfterEachArrow,
      'scoreValues': instance.scoreValues
          .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
      'groups': instance.groups.map((e) => e.toJson()).toList(),
      'subgroups': instance.subgroups.map((e) => e.toJson()).toList(),
      'targets': instance.targets.map((e) => e.toJson()).toList(),
      'participants': instance.participants.map((e) => e.toJson()).toList(),
    };
