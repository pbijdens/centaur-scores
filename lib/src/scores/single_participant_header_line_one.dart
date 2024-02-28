import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

class SingleParticipantHeaderLineOne extends StatelessWidget {
  final MatchModel model;
  final ParticipantModel participant;
  final int index;

  const SingleParticipantHeaderLineOne(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: StyleHelper.scoreCardColumnWidth(model),
      child: Container(
          alignment: Alignment.topLeft,
          color: StyleHelper.colorForColumn(index),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(participant.name ?? "-",
                        textAlign: TextAlign.left,
                        style: StyleHelper.scoreFormHeaderParticipantNameTextStyle(context)),
                  ]))),
    );
  }
}
