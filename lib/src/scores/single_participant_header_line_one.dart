import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:flutter/material.dart';

class SingleParticipantHeaderLineOne extends StatelessWidget {
  MatchModel model;
  ParticipantModel participant;
  int index;

  SingleParticipantHeaderLineOne(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: ScoreFormHelper.preferredCellWidth * (model.ends + 2),
      child: 
        Container(
          alignment: Alignment.topLeft,
          color: ScoreFormHelper.colorForColumn(index),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(participant.name ?? "-",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ]))),
    );
  }
}
