import 'end_model.dart';

class ParticipantModel {
  late int id;
  late String lijn;
  String? name;
  String group = "-";
  String subgroup = "-";
  List<EndModel> ends = [];

  ParticipantModel();
  ParticipantModel.create({required this.lijn, required this.id});

  int get score => calculateScore();
  set score(int value) {}

  int calculateScore() {
    int score = 0;
    for (EndModel end in ends) {
      score += end.score ?? 0;
    }
    return score;
  }
}
