import 'package:centaur_scores/src/model/end_model.dart';
import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/model/participant_model.dart';

import 'group_info.dart';
import 'score_button_definition.dart';

class ModelFactory {
  static MatchModel createDebugModel() {
    MatchModel result = MatchModel();

    result.wedstrijdCode = "ICW8";
    result.wedstrijdNaam = "Competitie week 8 18/3";

    result.arrowsPerEnd = 3;
    result.ends = 10;

    result.autoProgressAfterEachArrow = false;
    result.deviceID = "n/a"; // should be provided by the server

    result.scoreValues = {
      "-": [
        ScoreButtonDefinition("10", 10),
        ScoreButtonDefinition("9", 9),
        ScoreButtonDefinition("8", 8),
        ScoreButtonDefinition("7", 7),
        ScoreButtonDefinition("6", 6),
        ScoreButtonDefinition("5", 5),
        ScoreButtonDefinition("4", 4),
        ScoreButtonDefinition("3", 3),
        ScoreButtonDefinition("2", 2),
        ScoreButtonDefinition("1", 1),
        ScoreButtonDefinition("Mis", 0),
        ScoreButtonDefinition("DEL", null)
      ],
      "C": [
        ScoreButtonDefinition("10", 10),
        ScoreButtonDefinition("9", 9),
        ScoreButtonDefinition("8", 8),
        ScoreButtonDefinition("7", 7),
        ScoreButtonDefinition("6", 6),
        ScoreButtonDefinition("Mis", 0),
        ScoreButtonDefinition("DEL", null)
      ],
      "R": [
        ScoreButtonDefinition("10", 10),
        ScoreButtonDefinition("9", 9),
        ScoreButtonDefinition("8", 8),
        ScoreButtonDefinition("7", 7),
        ScoreButtonDefinition("6", 6),
        ScoreButtonDefinition("5", 5),
        ScoreButtonDefinition("4", 4),
        ScoreButtonDefinition("3", 3),
        ScoreButtonDefinition("2", 2),
        ScoreButtonDefinition("1", 1),
        ScoreButtonDefinition("Mis", 0),
        ScoreButtonDefinition("DEL", null)
      ],
      "H": [
        ScoreButtonDefinition("10", 10),
        ScoreButtonDefinition("9", 9),
        ScoreButtonDefinition("8", 8),
        ScoreButtonDefinition("7", 7),
        ScoreButtonDefinition("6", 6),
        ScoreButtonDefinition("5", 5),
        ScoreButtonDefinition("4", 4),
        ScoreButtonDefinition("3", 3),
        ScoreButtonDefinition("2", 2),
        ScoreButtonDefinition("1", 1),
        ScoreButtonDefinition("MISS", 0),
        ScoreButtonDefinition("DEL", null)
      ],
    };

    result.participants = [
      ParticipantModel.create(id: 0, lijn: "A"),
      ParticipantModel.create(id: 1, lijn: "B"),
      ParticipantModel.create(id: 2, lijn: "C"),
      ParticipantModel.create(id: 3, lijn: "D"),
    ];

    result.groups = [
      GroupInfo("Onbekend", "-"),
      GroupInfo("Recurve", "R"),
      GroupInfo("Compound", "C"),
      GroupInfo("Hout/Barebow", "H")
    ];

    result.subgroups = [
      GroupInfo("Onbekend", "-"),
      GroupInfo("Senioren", "S"),
      GroupInfo("Junioren", "J")
    ];

    for (var participant in result.participants) {
      participant.ends = [];
      for (int endNo = 0; endNo < result.ends; endNo++) {
        var end = EndModel();
        end.arrows = [];
        for (int arrowNo = 0; arrowNo < result.arrowsPerEnd; arrowNo++) {
          end.arrows.add(null);
        }
        participant.ends.add(end);
      }
    }



    return result;
  }
}
