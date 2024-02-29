import 'package:centaur_scores/src/participants/participants_view.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../model/match_model.dart';
import '../model/participant_model.dart';

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
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const ParticipantsView(),
            ));
      },
      child: SizedBox(
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
                            style: StyleHelper
                                .scoreFormHeaderParticipantNameTextStyle(
                                    context)),
                      ])))),
    );
  }
}
