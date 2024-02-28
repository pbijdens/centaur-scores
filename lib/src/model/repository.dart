import 'model.dart';
import 'dart:async';

class MatchRepository {
  // SINGLETON PATTERN
  static final MatchRepository _instance = MatchRepository._internal();

  factory MatchRepository() {
    return _instance;
  }

  MatchRepository._internal() {
    print("Match repository was created.");
  }

  // DATA
  final Completer<MatchModel> completer = Completer<MatchModel>();

  Future<MatchModel> getModel() async {
    MatchModel model = await completer.future;
    return Future.value(model);
  }

  Future load() async {
    try {
      MatchModel model = MatchModel();
      await model.load();
      completer.complete(model);
    } catch (error) {
      completer.completeError(error);
    }
  }

  // OPERATIONS
  // STUBBED FOR NOW, SHOULD OF COURSE REGISTER THE OBJECT AS NEEDING SYNC ETC. AND WRITE TO THE LOCAL DB

  ParticipantModel setParticipantName(
      ParticipantModel participant, String name) {
    participant.setName(name);
    return participant;
  }

  ParticipantModel setParticipantGroup(
      ParticipantModel participant, GroupInfo group) {
    participant.setGroup(group);
    return participant;
  }

  ParticipantModel setParticipantSubgroup(
      ParticipantModel participant, GroupInfo subgroup) {
    participant.setSubgroup(subgroup);
    return participant;
  }

  ParticipantModel? getParticipantByIndex(MatchModel? model, int index) {
    return model?.participants.participants[index] ?? null;
  }
}
