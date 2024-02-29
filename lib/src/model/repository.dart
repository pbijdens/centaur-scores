import 'package:localstorage/localstorage.dart';

import 'group_info.dart';
import 'match_model.dart';
import 'model_factory.dart';
import 'dart:async';

import 'participant_model.dart';

class MatchRepository {
  // SINGLETON PATTERN
  static final MatchRepository _instance = MatchRepository._internal();

  factory MatchRepository() {
    return _instance;
  }

  final LocalStorage storage = LocalStorage('match-repository');

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
      await storage.ready;

      MatchModel model;
      try {
        // model = storage.getItem('model');
        model = ModelFactory.createDebugModel();
      } catch (error) {
        model = ModelFactory.createDebugModel();
      }

      completer.complete(model);
    } catch (error) {
      completer.completeError(error);
    }
  }

  // OPERATIONS
  // STUBBED FOR NOW, SHOULD OF COURSE REGISTER THE OBJECT AS NEEDING SYNC ETC. AND WRITE TO THE LOCAL DB

  Future setParticipantName(int participantId, String name) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.name = name;
        return;
      }
    }
  }

  Future setParticipantGroup(int participantId, GroupInfo group) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.group = group.code;
        return;
      }
    }
  }

  Future setParticipantSubgroup(int participantId, GroupInfo subgroup) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.subgroup = subgroup.code;
        return;
      }
    }
  }

  Future<ParticipantModel?> getParticipantByIndex(
      MatchModel? model, int index) async {
    MatchModel model = await getModel();
    return model.participants[index];
  }

  Future setArrow(int participantId, int endNo, int arrowNo, int? value) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {        
        participant.ends[endNo].arrows[arrowNo] = value;
        return;
      }
    }
  }
}
