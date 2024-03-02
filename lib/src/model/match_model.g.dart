// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel()
  ..id = json['id'] as int
  ..deviceID = json['deviceID'] as String
  ..matchCode = json['wedstrijdCode'] as String
  ..matchName = json['wedstrijdNaam'] as String
  ..numberOfEnds = json['ends'] as int
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
  ..participants = (json['participants'] as List<dynamic>)
      .map((e) => ParticipantModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceID': instance.deviceID,
      'wedstrijdCode': instance.matchCode,
      'wedstrijdNaam': instance.matchName,
      'ends': instance.numberOfEnds,
      'arrowsPerEnd': instance.arrowsPerEnd,
      'autoProgressAfterEachArrow': instance.autoProgressAfterEachArrow,
      'scoreValues': instance.scoreValues,
      'groups': instance.groups,
      'subgroups': instance.subgroups,
      'participants': instance.participants,
    };
