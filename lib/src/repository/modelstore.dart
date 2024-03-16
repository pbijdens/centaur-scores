import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/model/settings_model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

class ModelStore {
  static final ModelStore _instance = ModelStore._internal();

  factory ModelStore() {
    return _instance;
  }

  ModelStore._internal() {
    print("ModelStore was created.");
  }

  // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

  final LocalStorage storage = LocalStorage('match-repository.json');

  Future<MatchModel?> loadModel() async {
    await storage.ready;

    var loadedModel = await storage.getItem('model');
    if (null == loadedModel) {
      return null;
    } else {
      MatchModel result = MatchModel.fromJson(loadedModel);
      return result;
    }
  }

  Future<void> saveModel(MatchModel model) async {
    await storage.ready;
    await storage.setItem('model', model.toJson());
  }

  Future<String> generateUniqueDeviceID() async {
    String deviceID = const Uuid().v4();
    await storage.setItem('deviceID', deviceID);
    return deviceID;
  }

  Future<String> getDeviceID() async {
    var settings = await loadSettings();
    return settings.deviceID;
  }

  Future<String> getServerURL() async {
    var settings = await loadSettings();
    var serverURL = settings.serverURL;
    while (serverURL.endsWith('/')) {
      serverURL = serverURL.substring(0, serverURL.length - 1);
    }    
    return serverURL;
  }

  Future<void> setServerURL(String url) async {
    var settings = await loadSettings();
    settings.serverURL = url;
    await saveSettings(settings);
  }

  Future<SettingsModel> loadSettings() async {
    await storage.ready;

    var loadedSettings = await storage.getItem('settings');
    if (loadedSettings == null) {
      SettingsModel settings = SettingsModel();
      settings.deviceID = const Uuid().v4();
      settings.serverURL = MatchRepository.hardcodedURL;
      await saveSettings(settings);
      return settings;
    } else {
      SettingsModel settings = SettingsModel.fromJson(loadedSettings);
      return settings;
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await storage.ready;
    await storage.setItem('settings', settings.toJson());
  }
}
