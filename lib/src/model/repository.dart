import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'group_info.dart';
import 'match_model.dart';
import '../debug/model_factory.dart';
import 'dart:async';

import 'participant_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

//
// to generate code for the JSON files besed on the JSON annotations:
//   flutter packages pub run build_runner build
//

class MatchRepository with ChangeNotifier {
  // SINGLETON PATTERN
  static final MatchRepository _instance = MatchRepository._internal();

  // If the system is not configured, it tries to use this URL to fetch its data
  static const String hardcodedURL = "http://192.168.2.3:8062";

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
      print("Completing completer with demo data...");
      completer.complete(model);
    } catch (error) {
      print('demo(): $error');
      completer.completeError(error);
    }
    notifyListeners();
  }

  Future loadFromStorage() async {
    completer = Completer<MatchModel>();
    try {
      await storage.ready;

      MatchModel model;
      dynamic modelFromStorage = storage.getItem('model');
      if (null == modelFromStorage ||
          modelFromStorage is! Map<String, dynamic>) {
        print('No model found in storage, checking remote feed first.');
        await initializeAppFromRemoteModelOnly();
      } else {
        Map<String, dynamic> loadedModel = modelFromStorage;
        print('Loaded model from local storage: ${jsonEncode(loadedModel)}');
        model = MatchModel.fromJson(loadedModel);
        model.deviceID = await getDeviceID();

        print("Completing completer...");
        completer.complete(model);
      }
    } catch (error) {
      print(
          'Error loading data: $error - trying remote model (again) instead...');
      await initializeAppFromRemoteModelOnly();
    }
    notifyListeners();
  }

  Future<void> initializeAppFromRemoteModelOnly() async {
    try {
      print('Getting remote model...');
      MatchModel remoteModel = await getRemoteModel();
      print('Model = ${jsonEncode(remoteModel.toJson())}');
      print('Getting the device ID...');
      remoteModel.deviceID = await getDeviceID();
      print('Device ID = ${remoteModel.deviceID}');
      print("Completing completer...");
      completer.complete(remoteModel);
      print('Done');
    } catch (error) {
      print('Loading remote model failed with error: $error');
      MatchModel emptyModel = ModelFactory.createEmptyModel();
      emptyModel.deviceID = await getDeviceID();
      print("Completing completer from catch...");
      completer.complete(emptyModel);
    }
  }

  Future registerChangeLocally() async {
    try {
      await storage.ready;
      MatchModel model = await getModel();
      model.isDirty = true;
      model.deviceID = await getDeviceID();
      await storage.setItem('model', model.toJson());
    } catch (error) {
      print("Failed to save model to storage: $error");
    } finally {
      print("Done with registerChangeLocally...");
    }
  }

  Future setParticipantName(int participantId, String name) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.name = name;
        await registerChangeLocally();
        return;
      }
    }
  }

  Future setParticipantGroup(int participantId, GroupInfo group) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.group = group.code;
        await registerChangeLocally();
        return;
      }
    }
  }

  Future setParticipantSubgroup(int participantId, GroupInfo subgroup) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.subgroup = subgroup.code;
        await registerChangeLocally();
        return;
      }
    }
  }

  Future setParticipantTarget(int participantId, GroupInfo target) async {
    MatchModel model = await getModel();
    for (var participant in model.participants) {
      if (participant.id == participantId) {
        participant.target = target.code;
        await registerChangeLocally();
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
        await registerChangeLocally();
        return;
      }
    }
  }

  Future<String> getDeviceID() async {
    await storage.ready;
    String? deviceID = storage.getItem('deviceID');
    if (deviceID == null || deviceID.isEmpty) {
      deviceID = const Uuid().v4();
      await storage.setItem('deviceID', deviceID);
    }
    return deviceID;
  }

  Future<String> getServerURL() async {
    await storage.ready;
    String? serverURL = storage.getItem('serverURL');
    if (serverURL == null || serverURL.isEmpty) {
      serverURL = hardcodedURL;
      await storage.setItem('serverURL', serverURL);
    }
    while (serverURL!.endsWith('/')) {
      serverURL = serverURL.substring(0, serverURL.length - 1);
    }
    return serverURL;
  }

  Future<String> setServerURL(String value) async {
    await storage.ready;
    await storage.setItem('serverURL', value);
    return value;
  }

  Future<String> synchronizeWithRemoteSystem() async {
    try {
      MatchModel localModel = await getModel();
      MatchModel remoteModel = await getRemoteModel();
      if (remoteModel.id != localModel.id) {
        print(
            "Remote model does not match local model. Replacing local model...");
        completer = Completer<MatchModel>();
        print("Completing completer after sync...");
        completer.complete(remoteModel);
        await storage.setItem('model', remoteModel.toJson());
        // RESET DEVICE, ACTIVE MATCH CHANGED
        return 'RESET';
      } else if (localModel.isDirty) {
        try {
          await pushParticipants(remoteModel.id, localModel.participants);
          localModel.isDirty = false;
        } catch (error) {
          print('An error occurred pushing participants: $error');
          return 'ERROR: $error';
        }
      }
    } catch (error) {
      print('synchronizeWithRemoteSystem failed with error $error');
      return 'ERROR: $error';
    }
    return 'OK';
  }

  Future<bool> pushParticipants(
      int matchId, List<ParticipantModel> participants) async {
    String baseUrl = await getServerURL();
    var deviceID = await getDeviceID();
    var client = http.Client();
    var uri = Uri.parse('$baseUrl/match/$matchId/participants/$deviceID');
    Map<String, String> headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';
    var response =
        await client.put(uri, headers: headers, body: jsonEncode(participants));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw 'Request to $baseUrl/match/$matchId/participants/$deviceID failed with status ${response.statusCode}';
    }
  }

  Future<MatchModel> getRemoteModel() async {
    String baseUrl = await getServerURL();

    MatchModel activeMatchModel = await httpGetActiveMatchModel(baseUrl);
    List<ParticipantModel> participants =
        await httpGetGetParticipantsForMatch(baseUrl, activeMatchModel.id);

    activeMatchModel.participants = participants;

    return activeMatchModel;
  }

  Future<MatchModel> httpGetActiveMatchModel(String baseUrl) async {
    var client = http.Client();
    var uri = Uri.parse('${baseUrl}/match/active');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> result =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes))
              as Map<String, dynamic>;
      result['isDirty'] = jsonDecode("false");
      result['participants'] = jsonDecode("[]");
      return MatchModel.fromJson(result);
    } else {
      throw 'Request to $baseUrl/match/active failed with status ${response.statusCode}';
    }
  }

  Future<List<ParticipantModel>> httpGetGetParticipantsForMatch(
      String baseUrl, int matchId) async {
    var deviceID = await getDeviceID();
    var client = http.Client();
    var uri = Uri.parse('${baseUrl}/match/$matchId/participants/$deviceID');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      List result = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      var resultList = result.map((item) {
        if (item['name'] == null) {
          item['name'] = '';
        }
        return ParticipantModel.fromJson(item);
      }).toList();
      resultList.sort((a, b) => a.lijn.compareTo(b.lijn));
      for (int i = 0; i < resultList.length; i++) {
        resultList[i].id = i + 1;
      }
      return resultList;
    } else {
      throw 'Request to $baseUrl/match/active failed with status ${response.statusCode}';
    }
  }
}
