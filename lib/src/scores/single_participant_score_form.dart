import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:flutter/material.dart';

class SingeParticipantScoreForm extends StatelessWidget {
  MatchModel model;
  ParticipantModel participant;
  int index;

  SingeParticipantScoreForm(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: ScoreFormHelper.preferredCellWidth * (model.ends + 2),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(1),
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: model.arrowsPerEnd + 2,
        scrollDirection: Axis.vertical,
        childAspectRatio: ScoreFormHelper.childAspectRatio,
        children: createScoreRows(context),
      ),
    );
  }

  List<Widget> createScoreRows(BuildContext context) {
    List<Widget> result = [];
    for (var endNo = 0; endNo < model.ends; endNo++) {
      result.add(SizedBox(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            child: Text('${endNo + 1}',
                style: Theme.of(context).textTheme.titleLarge),
          )));

      int endTotal = 0;
      bool endFilled = false;
      for (var arrowNo = 0; arrowNo < model.arrowsPerEnd; arrowNo++) {
        endFilled =
            endFilled && (participant.ends[endNo].arrows[arrowNo] != null);
        result.add(Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              color: ScoreFormHelper.colorForArrow(
                  model, participant.ends[endNo].arrows[arrowNo]),
              child: Text('${participant.ends[endNo].arrows[arrowNo] ?? "-"}',
                  style: Theme.of(context).textTheme.titleLarge),
            ));
      }

      result.add(Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Text('${endFilled ? endTotal : "-"}',
                style: Theme.of(context).textTheme.titleLarge),
          ));
    }
    return result;
  }
}
