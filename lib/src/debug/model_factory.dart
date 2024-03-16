import 'package:centaur_scores/src/model/match_model.dart';

import '../model/group_info.dart';
import '../model/score_button_definition.dart';

class ModelFactory {
  static int nextID = 1;

  static MatchModel createEmptyModel() {
    MatchModel result = MatchModel();

    result.id = nextID++;

    result.matchCode = "";
    result.matchName = "";

    result.arrowsPerEnd = 3;
    result.numberOfEnds = 10;

    result.autoProgressAfterEachArrow = false;
    result.deviceID = "n/a"; // should be provided by the server

    result.scoreValues = {
      "": [
        ScoreButtonDefinition.create(nextID++, "10", 10),
        ScoreButtonDefinition.create(nextID++, "9", 9),
        ScoreButtonDefinition.create(nextID++, "8", 8),
        ScoreButtonDefinition.create(nextID++, "7", 7),
        ScoreButtonDefinition.create(nextID++, "6", 6),
        ScoreButtonDefinition.create(nextID++, "5", 5),
        ScoreButtonDefinition.create(nextID++, "4", 4),
        ScoreButtonDefinition.create(nextID++, "3", 3),
        ScoreButtonDefinition.create(nextID++, "2", 2),
        ScoreButtonDefinition.create(nextID++, "1", 1),
        ScoreButtonDefinition.create(nextID++, "Mis", 0),
        ScoreButtonDefinition.create(nextID++, "DEL", null)
      ]  
    };

    result.participants = [
    ];

    result.groups = [
      GroupInfo.create(nextID++, "Not loaded", ""),
    ];

    result.subgroups = [
      GroupInfo.create(nextID++, "Not loaded", ""),
    ];

    result.targets = [
      GroupInfo.create(nextID++, "Not loaded", ""),
    ];

    return result;
  }
}
