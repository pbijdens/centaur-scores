import 'package:centaur_scores/src/repository/centaur_scores_api.dart';
import 'package:centaur_scores/src/repository/modelstore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../model/group_info.dart';
import '../model/match_model.dart';
import '../model/participant_model.dart';

//
// to generate code for the JSON files besed on the JSON annotations:
//   flutter packages pub run build_runner build
//

class MatchRepository with ChangeNotifier {
  // SINGLETON PATTERN
  static final MatchRepository _instance = MatchRepository._internal();

  // If the system is not configured, it tries to use this URL to fetch its data
  static const String hardcodedURL = "http://192.168.50.236:8062";

  factory MatchRepository() {
    return _instance;
  }

  MatchRepository._internal() {
    print("Match repository was created.");
    _timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => _timerFunction());
  }

  final ModelStore _store = ModelStore();
  final CentaurScoresAPI _api = CentaurScoresAPI();

  // Singleton timer to trigger upload of scores and participants
  Timer? _timer;

  // Invoked when the global model is replaced (init, change of active match)
  Function(Completer<MatchModel>)? onModelReplaced;
  bool? currentIsDirtyState;
  // Completer for fetching the model once; replaced only when the model needs to be changed.
  // After  the completer changes, onModelReplaced is invoked, followed by notifyListeners()
  Completer<MatchModel> _globalModelCompleter = Completer<MatchModel>();

  Future<MatchModel> getModel() async {
    MatchModel model = await _globalModelCompleter.future;
    return Future.value(model);
  }

  Future initialize() async {
    _globalModelCompleter = Completer<MatchModel>();
    if (null != onModelReplaced) onModelReplaced!(_globalModelCompleter);

    try {
      MatchModel? localModel = await _store.loadModel();
      MatchModel? remoteModel = await loadRemoteModelOrNull();

      MatchModel result;
      if (null == localModel && null != remoteModel) {
        // There is only a remote model
        print("Initialize: Only found remote model...");
        result = remoteModel;
        result.deviceID = await _store.getDeviceID();
        _globalModelCompleter.complete(result);
      } else if (null == remoteModel && null != localModel) {
        print("Initialize: Only found local model...");
        result = localModel;
        result.deviceID = await _store.getDeviceID();
        _globalModelCompleter.complete(result);
      } else if (null != remoteModel && null != localModel) {
        print("Initialize: Found both models, preferring local model...");
        result = localModel; // TODO: MERGE
        result.deviceID = await _store.getDeviceID();
        _globalModelCompleter.complete(result);
      } else {
        print("Initialize: Found no model... Not completing...");
      }
    } catch (error) {
      print("Initialize: Error loading model... Not completing... => $error");
    }
    notifyListeners();
  }

  Future<MatchModel?> loadRemoteModelOrNull() async {
    try {
      MatchModel remoteModel = await getRemoteModel();
      return remoteModel;
    } catch (error) {
      print('Could not fetch remote model: $error');
      return null;
    }
  }

  Future markModelDirtyAndSaveLocally(MatchModel model) async {
    try {
      model.isDirty = true;
      model.deviceID = await _store.getDeviceID();
      await _store.saveModel(model);
      notifyListeners();
    } catch (error) {
      print("Failed to save model to storage: $error");
    } finally {
      print("Done: markModelDirtyAndSaveLocally...");
    }
  }

  Future setParticipantName(int participantId, String name) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.name = name;
        await markModelDirtyAndSaveLocally(model);
        return;
      }
    }
  }

  Future setParticipantGroup(int participantId, GroupInfo group) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.group = group.code;
        await markModelDirtyAndSaveLocally(model);
        return;
      }
    }
  }

  Future setParticipantSubgroup(int participantId, GroupInfo subgroup) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.subgroup = subgroup.code;
        await markModelDirtyAndSaveLocally(model);
        return;
      }
    }
  }

  Future setParticipantTarget(int participantId, GroupInfo target) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.target = target.code;
        await markModelDirtyAndSaveLocally(model);
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
        await markModelDirtyAndSaveLocally(model);
        return;
      }
    }
  }

  Future<String> getServerURL() async {
    return await _store.getServerURL();
  }

  Future<String> setServerURL(String value) async {
    _store.setServerURL(value);
    return value;
  }

  Future<MatchModel> getRemoteModel() async {
    MatchModel activeMatchModel = await _api.httpGetActiveMatchModel();
    List<ParticipantModel> participants =
        await _api.httpGetParticipantsForMatch(activeMatchModel.id);

    activeMatchModel.participants = participants;

    return activeMatchModel;
  }

  void _timerFunction() {
    print("timer...");
    getModel().then((model) {
      bool newDirty = model.isDirty;

      if (currentIsDirtyState == null || newDirty != currentIsDirtyState) {
        _sync().catchError((err) {
          print("sync failed");
        }).then((result) {
          print("sync done");
          currentIsDirtyState = result;
        });
      }

      // Sync was completed already, now check to see if we need to ditch this match
      _checkIfActiveMatchChanged().then((value) {});
    });
  }

  Future<bool> _sync() async {
    try {
      var model = await getModel();
      if (model.isDirty) {
        print('Model is dirty, pushing...');
        await _api.pushParticipants(model.id, model.participants);
        model.isDirty = false;
        await _store.saveModel(model);
        notifyListeners();
        print('Model is no longer dirty...');
        return false;
      } else {
        print('Model is not dirty.');
        return false;
      }
    } catch (error) {
      print("ERROR: $error");
    } finally {
      print('End of sync action...');
    }
    return true;
  }

  Future<Null> _checkIfActiveMatchChanged() async {
    try {
      MatchModel localModel = await getModel();
      MatchModel remoteModel = await getRemoteModel();
      if (remoteModel.id != localModel.id) {
        print(
            "Active match changed from ${localModel.id} to ${remoteModel.id}");

        // Replace the model with the server-provided value
        _globalModelCompleter = Completer<MatchModel>();
        if (null != onModelReplaced) onModelReplaced!(_globalModelCompleter);
        _globalModelCompleter.complete(remoteModel);

        // Save this new model locally to start off hte JSON cache
        await _store.saveModel(remoteModel);
        notifyListeners();
      }
    } catch (error) {
      print('checkIfActiveMatchChanged failed with error $error');
    }
  }
}
