import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SingleParticipantHeaderLineTwo extends StatelessWidget {
  final MatchModel model;
  final ParticipantModel participant;
  final int index;

  const SingleParticipantHeaderLineTwo(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    var group = model.groups
            .where((element) => element.code == participant.group)
            .firstOrNull ??
        GroupInfo("Onbekend", "-");
    var subgroup = model.subgroups
            .where((element) => element.code == participant.subgroup)
            .firstOrNull ??
        GroupInfo("Onbekend", "-");

    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: ScoreFormHelper.scoreCardColumnWidth(model),
      //height: 80,
      child: Container(
          alignment: Alignment.topLeft,
          color: ScoreFormHelper.colorForColumnFooter(index),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Lijn: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: participant.lijn),
                    ],
                  ))),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(
                          text: ' Klasse: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: group.label),
                      const TextSpan(
                          text: ' / ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: subgroup.label),
                    ],
                  ),
                )
              ]))),
    );
  }
}
