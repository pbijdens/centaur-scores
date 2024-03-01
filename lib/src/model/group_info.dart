import 'package:json_annotation/json_annotation.dart';

part 'group_info.g.dart';

@JsonSerializable()
class GroupInfo {
  late String label;
  late String code;

  GroupInfo();
  GroupInfo.create(this.label, this.code);

  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);
}
