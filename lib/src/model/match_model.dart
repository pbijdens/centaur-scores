import 'package:centaur_scores/src/model/group_info.dart';
import 'package:centaur_scores/src/model/participant_model.dart';
import 'package:centaur_scores/src/model/score_button_definition.dart';

class MatchModel {
  late String deviceID;
  late String wedstrijdCode;
  late String wedstrijdNaam;
  late int ends;
  late int arrowsPerEnd;
  late bool autoProgressAfterEachArrow;
  late Map<String, List<ScoreButtonDefinition>> scoreValues;
  late List<GroupInfo> groups;
  late List<GroupInfo> subgroups;
  late List<ParticipantModel> participants;

  ParticipantModel? getParticipantByIndex(int index) {
    return (index < 0 || index >= participants.length) ? null : participants[index];
  }
}
