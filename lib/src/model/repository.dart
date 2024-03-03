import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'group_info.dart';
import 'match_model.dart';
import '../debug/model_factory.dart';
import 'dart:async';

import 'participant_model.dart';
import 'package:uuid/uuid.dart';

//
// to generate annotation files:
//flutter packages pub run build_runner build
//

class MatchRepository with ChangeNotifier {
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
  Completer<MatchModel> completer = Completer<MatchModel>();

  Future<MatchModel> getModel() async {
    MatchModel model = await completer.future;
    return Future.value(model);
  }

  Future demo() async {
    completer = Completer<MatchModel>();
    try {
      await storage.ready;
      MatchModel model = ModelFactory.createDebugModel();
      completer.complete(model);
    } catch (error) {
      completer.completeError(error);
    }
    notifyListeners();
  }

  Future load() async {
    completer = Completer<MatchModel>();
    try {
      await storage.ready;

      MatchModel model;
      try {
        Map<String, dynamic> loadedModel = storage.getItem('model');
        model = MatchModel.fromJson(loadedModel);
        model.deviceID = await getDeviceID();
      } catch (error) {
        model = ModelFactory.createDebugModel();
        model.deviceID = await getDeviceID();
      }

      completer.complete(model);
    } catch (error) {
      completer.completeError(error);
    }
    notifyListeners();
  }

  Future save() async {
    print("Saving model...");
    try {
      await storage.ready;
      MatchModel model = await getModel();
      model.deviceID = await getDeviceID();
      storage.setItem('model', model);
    } catch (error) {
      print("Failed to save model...");
      print(error);
    } finally {
      print("Done saving model...");
    }
  }

  // OPERATIONS
  // STUBBED FOR NOW, SHOULD OF COURSE REGISTER THE OBJECT AS NEEDING SYNC ETC. AND WRITE TO THE LOCAL DB

  Future setParticipantName(int participantId, String name) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.name = name;
        await save();
        return;
      }
    }
  }

  Future setParticipantGroup(int participantId, GroupInfo group) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.group = group.code;
        await save();
        return;
      }
    }
  }

  Future setParticipantSubgroup(int participantId, GroupInfo subgroup) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.subgroup = subgroup.code;
        await save();
        return;
      }
    }
  }

  Future setParticipantTarget(int participantId, GroupInfo target) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.target = target.code;
        await save();
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
        await save();
        return;
      }
    }
  }

  Future<String> getDeviceID() async {
    await storage.ready;
    String? deviceID = storage.getItem('deviceID');
    if (deviceID == null || deviceID.isEmpty) {
      deviceID = const Uuid().v4();
      storage.setItem('deviceID', deviceID);
    }
    return deviceID;
  }
}
