import 'package:json_annotation/json_annotation.dart';

part 'score_button_definition.g.dart';

@JsonSerializable(explicitToJson: true)
class ScoreButtonDefinition {
  ScoreButtonDefinition();
  ScoreButtonDefinition.create(this.id, this.label, this.value);
  late int id;
  late String label;
  late int? value;

  factory ScoreButtonDefinition.fromJson(Map<String, dynamic> json) =>
      _$ScoreButtonDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreButtonDefinitionToJson(this);    
}
