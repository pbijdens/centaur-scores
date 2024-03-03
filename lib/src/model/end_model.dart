import 'package:json_annotation/json_annotation.dart';

part 'end_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EndModel {
  late int id;
  late List<int?> arrows;

  int? get score => calculateScore();
  set score(int? value) {}

  factory EndModel.fromJson(Map<String, dynamic> json) => _$EndModelFromJson(json);
  Map<String, dynamic> toJson() => _$EndModelToJson(this);

  int? calculateScore() {
    int sum = 0;
    bool isNull = true;
    for (var element in arrows) {
      sum += element ?? 0;
      isNull = isNull && (element == null);
    }
    return isNull ? null : sum;
  }

  EndModel();
}
