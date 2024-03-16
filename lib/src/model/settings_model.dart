import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SettingsModel {
  late String deviceID;
  late String serverURL;

  SettingsModel.create(this.deviceID, this.serverURL);

  SettingsModel();

  factory SettingsModel.fromJson(Map<String, dynamic> json) => _$SettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
}
