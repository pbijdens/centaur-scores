import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../../model/match_model.dart';
import '../../model/participant_model.dart';

class SingeParticipantFooter extends StatelessWidget {
  final MatchModel model;
  final ParticipantModel participant;
  final int index;

  const SingeParticipantFooter(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
        color: StyleHelper.colorForColumnFooter(index),
        child: SizedBox(
          width: StyleHelper.scoreCardColumnWidth(model),
          child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Totaal: ${participant.score}',
                      textAlign: TextAlign.center,
                      style: StyleHelper.scoreFormFooterTextStyle(context)))),
        );
  }
}
