// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel()
      ..deviceID = json['deviceID'] as String
      ..serverURL = json['serverURL'] as String;

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'deviceID': instance.deviceID,
      'serverURL': instance.serverURL,
    };
