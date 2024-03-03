import 'package:json_annotation/json_annotation.dart';

part 'group_info.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupInfo {
  late int id;
  late String label;
  late String code;

  GroupInfo();
  GroupInfo.create(this.id, this.label, this.code);

  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);
}
