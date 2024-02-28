import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
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
      width: StyleHelper.scoreCardColumnWidth(model),
      //height: 80,
      child: Container(
          alignment: Alignment.topLeft,
          color: StyleHelper.colorForColumnFooter(index),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: RichText(
                  text: TextSpan(
                    text: '',
                    style: StyleHelper.scoreFormHeaderLineTwoTextStyle(context),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Lijn: ',
                          style: StyleHelper.scoreFormHeaderLineTwoBoldTextStyle(context)),
                      TextSpan(text: participant.lijn),
                    ],
                  ))),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: StyleHelper.scoreFormHeaderLineTwoTextStyle(context),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Klasse: ',
                          style: StyleHelper.scoreFormHeaderLineTwoBoldTextStyle(context)),
                      TextSpan(text: group.label),
                      TextSpan(
                          text: ' / ',
                          style: StyleHelper.scoreFormHeaderLineTwoBoldTextStyle(context)),
                      TextSpan(text: subgroup.label),
                    ],
                  ),
                )
              ]))),
    );
  }
}
