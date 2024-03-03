import 'package:centaur_scores/src/model/group_info.dart';
import 'package:centaur_scores/src/model/participant_model.dart';
import 'package:centaur_scores/src/model/score_button_definition.dart';
import 'package:json_annotation/json_annotation.dart';

part 'match_model.g.dart';

@JsonSerializable()
class MatchModel {
  late int id;
  late String deviceID;
  late String matchCode;
  late String matchName;
  late int numberOfEnds;
  late int arrowsPerEnd;
  late bool autoProgressAfterEachArrow;
  late Map<String, List<ScoreButtonDefinition>> scoreValues;
  late List<GroupInfo> groups;
  late List<GroupInfo> subgroups;
  late List<GroupInfo> targets;
  late List<ParticipantModel> participants;

  ParticipantModel? getParticipantByIndex(int index) {
    return (index < 0 || index >= participants.length)
        ? null
        : participants[index];
  }

  MatchModel();

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
  Map<String, dynamic> toJson() => _$MatchModelToJson(this);
}
