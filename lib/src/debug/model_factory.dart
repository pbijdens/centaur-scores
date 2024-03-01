import 'package:centaur_scores/src/model/end_model.dart';
import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/model/participant_model.dart';

import '../model/group_info.dart';
import '../model/score_button_definition.dart';

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
        ScoreButtonDefinition.create("12", 12),
        ScoreButtonDefinition.create("11", 11),
        ScoreButtonDefinition.create("10", 10),
        ScoreButtonDefinition.create("9", 9),
        ScoreButtonDefinition.create("8", 8),
        ScoreButtonDefinition.create("7", 7),
        ScoreButtonDefinition.create("6", 6),
        ScoreButtonDefinition.create("5", 5),
        ScoreButtonDefinition.create("4", 4),
        ScoreButtonDefinition.create("3", 3),
        ScoreButtonDefinition.create("2", 2),
        ScoreButtonDefinition.create("1", 1),
        ScoreButtonDefinition.create("Mis", 0),
        ScoreButtonDefinition.create("DEL", null)
      ],
      "C": [
        ScoreButtonDefinition.create("12", 12),
        ScoreButtonDefinition.create("11", 11),
        ScoreButtonDefinition.create("10", 10),
        ScoreButtonDefinition.create("9", 9),
        ScoreButtonDefinition.create("8", 8),
        ScoreButtonDefinition.create("7", 7),
        ScoreButtonDefinition.create("6", 6),
        ScoreButtonDefinition.create("Mis", 0),
        ScoreButtonDefinition.create("DEL", null)
      ],
      "R": [
        ScoreButtonDefinition.create("12", 12),
        ScoreButtonDefinition.create("11", 11),
        ScoreButtonDefinition.create("10", 10),
        ScoreButtonDefinition.create("9", 9),
        ScoreButtonDefinition.create("8", 8),
        ScoreButtonDefinition.create("7", 7),
        ScoreButtonDefinition.create("6", 6),
        ScoreButtonDefinition.create("5", 5),
        ScoreButtonDefinition.create("4", 4),
        ScoreButtonDefinition.create("3", 3),
        ScoreButtonDefinition.create("2", 2),
        ScoreButtonDefinition.create("1", 1),
        ScoreButtonDefinition.create("Mis", 0),
        ScoreButtonDefinition.create("DEL", null)
      ],
      "H": [
        ScoreButtonDefinition.create("12", 12),
        ScoreButtonDefinition.create("11", 11),
        ScoreButtonDefinition.create("10", 10),
        ScoreButtonDefinition.create("9", 9),
        ScoreButtonDefinition.create("8", 8),
        ScoreButtonDefinition.create("7", 7),
        ScoreButtonDefinition.create("6", 6),
        ScoreButtonDefinition.create("5", 5),
        ScoreButtonDefinition.create("4", 4),
        ScoreButtonDefinition.create("3", 3),
        ScoreButtonDefinition.create("2", 2),
        ScoreButtonDefinition.create("1", 1),
        ScoreButtonDefinition.create("MISS", 0),
        ScoreButtonDefinition.create("DEL", null)
      ],
    };

    result.participants = [
      ParticipantModel.create(id: 0, lijn: "A"),
      ParticipantModel.create(id: 1, lijn: "B"),
      ParticipantModel.create(id: 2, lijn: "C"),
      ParticipantModel.create(id: 3, lijn: "D"),
    ];
    result.participants[0].name = "Jan de Vries";
    result.participants[0].group = "R";
    result.participants[0].subgroup = "S";

    result.participants[1].name = "Klaas van de Groep";
    result.participants[1].group = "C";
    result.participants[1].subgroup = "S";

    result.participants[2].name = "Freek van het Dorp";
    result.participants[2].group = "H";
    result.participants[2].subgroup = "S";

    result.groups = [
      GroupInfo.create("Onbekend", "-"),
      GroupInfo.create("Recurve", "R"),
      GroupInfo.create("Compound", "C"),
      GroupInfo.create("Hout/Barebow", "H")
    ];

    result.subgroups = [
      GroupInfo.create("Onbekend", "-"),
      GroupInfo.create("Senioren", "S"),
      GroupInfo.create("Junioren", "J")
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
