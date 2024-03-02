import 'package:centaur_scores/src/model/end_model.dart';
import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/model/participant_model.dart';

import '../model/group_info.dart';
import '../model/score_button_definition.dart';

class ModelFactory {
  static int nextID = 1;

  static MatchModel createDebugModel() {
    MatchModel result = MatchModel();

    result.id = nextID++;

    result.matchCode = "ICW8";
    result.matchName = "Competitie week 8 18/3";

    result.arrowsPerEnd = 3;
    result.numberOfEnds = 10;

    result.autoProgressAfterEachArrow = false;
    result.deviceID = "n/a"; // should be provided by the server

    result.scoreValues = {
      "-": [
        ScoreButtonDefinition.create(nextID++, "12", 12),
        ScoreButtonDefinition.create(nextID++, "11", 11),
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
      ],
      "C": [
        ScoreButtonDefinition.create(nextID++, "12", 12),
        ScoreButtonDefinition.create(nextID++, "11", 11),
        ScoreButtonDefinition.create(nextID++, "10", 10),
        ScoreButtonDefinition.create(nextID++, "9", 9),
        ScoreButtonDefinition.create(nextID++, "8", 8),
        ScoreButtonDefinition.create(nextID++, "7", 7),
        ScoreButtonDefinition.create(nextID++, "6", 6),
        ScoreButtonDefinition.create(nextID++, "Mis", 0),
        ScoreButtonDefinition.create(nextID++, "DEL", null)
      ],
      "R": [
        ScoreButtonDefinition.create(nextID++, "12", 12),
        ScoreButtonDefinition.create(nextID++, "11", 11),
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
      ],
      "H": [
        ScoreButtonDefinition.create(nextID++, "12", 12),
        ScoreButtonDefinition.create(nextID++, "11", 11),
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
        ScoreButtonDefinition.create(nextID++, "MISS", 0),
        ScoreButtonDefinition.create(nextID++, "DEL", null)
      ],
    };

    result.participants = [
      ParticipantModel.create(id: nextID++, lijn: "A"),
      ParticipantModel.create(id: nextID++, lijn: "B"),
      ParticipantModel.create(id: nextID++, lijn: "C"),
      ParticipantModel.create(id: nextID++, lijn: "D"),
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
      GroupInfo.create(nextID++, "Onbekend", "-"),
      GroupInfo.create(nextID++, "Recurve", "R"),
      GroupInfo.create(nextID++, "Compound", "C"),
      GroupInfo.create(nextID++, "Hout/Barebow", "H")
    ];

    result.subgroups = [
      GroupInfo.create(nextID++, "Onbekend", "-"),
      GroupInfo.create(nextID++, "Senioren", "S"),
      GroupInfo.create(nextID++, "Junioren", "J")
    ];

    for (var participant in result.participants) {
      participant.ends = [];
      for (int endNo = 0; endNo < result.numberOfEnds; endNo++) {
        var end = EndModel();
        end.id = nextID++;
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
