import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:flutter/material.dart';

class SingeParticipantFooter extends StatelessWidget {
  MatchModel model;
  ParticipantModel participant;
  int index;

  SingeParticipantFooter(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
        color: ScoreFormHelper.colorForColumnFooter(index),
        child: SizedBox(
          width: ScoreFormHelper.scoreCardColumnWidth(model),
          child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Totaal: ${participant.score}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge))),
        );
  }
}
