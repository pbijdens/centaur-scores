import 'package:centaur_scores/src/model/participant_model.dart';
import 'package:centaur_scores/src/repository/modelstore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/match_model.dart';
import 'dart:developer';

class CentaurScoresAPI {
  static final CentaurScoresAPI _instance = CentaurScoresAPI._internal();

  factory CentaurScoresAPI() {
    return _instance;
  }

  CentaurScoresAPI._internal() {
    log("CentaurScoresAPI was created.");
  }

  // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

  final ModelStore _store = ModelStore();

  Future<bool> pushParticipants(
      int matchId, List<ParticipantModel> participants) async {
    String baseUrl = await _store.getServerURL();
    var deviceID = await _store.getDeviceID();
    var client = http.Client();
    var uri = Uri.parse('$baseUrl/match/$matchId/participants/$deviceID');
    Map<String, String> headers = <String, String>{};
    headers['Content-Type'] = 'application/json';
    var response =
        await client.put(uri, headers: headers, body: jsonEncode(participants));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw 'Request to $baseUrl/match/$matchId/participants/$deviceID failed with status ${response.statusCode}';
    }
  }

  Future<MatchModel> httpGetActiveMatchModel() async {
    String baseUrl = await _store.getServerURL();
    var client = http.Client();
    var uri = Uri.parse('$baseUrl/match/active');
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

  Future<List<ParticipantModel>> httpGetParticipantsForMatch(
      int matchId) async {
    String baseUrl = await _store.getServerURL();
    var deviceID = await _store.getDeviceID();
    var client = http.Client();
    var uri = Uri.parse('$baseUrl/match/$matchId/participants/$deviceID');
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

  Future<List<ParticipantModel>> httpGetAllParticipantsForMatch(
      int matchId) async {
    String baseUrl = await _store.getServerURL();
    var client = http.Client();
    var uri = Uri.parse('$baseUrl/match/$matchId/participants');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      List result = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      var resultList = result.map((item) {
        if (item['name'] == null) {
          item['name'] = '';
        }
        return ParticipantModel.fromJson(item);
      }).toList();
      resultList.sort((a, b) => '${a.deviceID}${a.lijn}${a.name}'
          .compareTo('${b.deviceID}${b.lijn}${b.name}'));
      return resultList;
    } else {
      throw 'Request to $uri failed with status ${response.statusCode}';
    }
  }

  Future<bool> moveParticipantToThisDevice(
      int matchId, ParticipantModel participant, String lijn) async {
    String baseUrl = await _store.getServerURL();
    var deviceID = await _store.getDeviceID();
    var client = http.Client();
    var uri = Uri.parse(
        '$baseUrl/match/$matchId/participants/${participant.id}/transfer/$deviceID/$lijn');
    Map<String, String> headers = <String, String>{};
    headers['Content-Type'] = 'application/json';
    var response = await client.post(uri, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw 'Request to $uri failed with status ${response.statusCode}';
    }
  }

  Future<bool> doesDeviceNeedSync() async {
    String baseUrl = await _store.getServerURL();
    var client = http.Client();
    var deviceID = await _store.getDeviceID();
    var uri = Uri.parse('$baseUrl/devices/$deviceID/sync');
    Map<String, String> headers = <String, String>{};
    headers['Content-Type'] = 'application/json';
    var response = await client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return const Utf8Decoder().convert(response.bodyBytes) == "true";
    } else {
      throw 'Request to $uri failed with status ${response.statusCode}';
    }
  }

  Future<bool> clearDeviceNeedSync() async {
    String baseUrl = await _store.getServerURL();
    var client = http.Client();
    var deviceID = await _store.getDeviceID();
    var uri = Uri.parse('$baseUrl/devices/$deviceID/sync');
    Map<String, String> headers = <String, String>{};
    headers['Content-Type'] = 'application/json';
    var response = await client.delete(uri, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw 'Request to $uri failed with status ${response.statusCode}';
    }
  }
}
