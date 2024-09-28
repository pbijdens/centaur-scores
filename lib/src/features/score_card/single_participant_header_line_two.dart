import 'package:centaur_scores/src/features/participants/participants_view.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../../model/group_info.dart';
import '../../model/match_model.dart';
import '../../model/participant_model.dart';

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
        GroupInfo.create(0, "Onbekend", "");
    var subgroup = model.subgroups
            .where((element) => element.code == participant.subgroup)
            .firstOrNull ??
        GroupInfo.create(0, "Onbekend", "");

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
          //height: 80,
          child: Container(
              alignment: Alignment.topLeft,
              color: StyleHelper.colorForColumnFooter(index),
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: RichText(
                                text: TextSpan(
                          text: '',
                          style: StyleHelper.scoreFormHeaderLineTwoTextStyle(
                              context),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Lijn: ',
                                style: StyleHelper
                                    .scoreFormHeaderLineTwoBoldTextStyle(
                                        context)),
                            TextSpan(text: participant.lijn),
                          ],
                        ))),
                        RichText(
                          text: TextSpan(
                            text: '',
                            style: StyleHelper.scoreFormHeaderLineTwoTextStyle(
                                context),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Klasse: ',
                                  style: StyleHelper
                                      .scoreFormHeaderLineTwoBoldTextStyle(
                                          context)),
                              TextSpan(text: restrictLength(group.label, 12)),
                              TextSpan(
                                  text: ' / ',
                                  style: StyleHelper
                                      .scoreFormHeaderLineTwoBoldTextStyle(
                                          context)),
                              TextSpan(
                                  text: restrictLength(subgroup.label, 12)),
                            ],
                          ),
                        )
                      ])))),
    );
  }

  String? restrictLength(String? input, int maxLength) {
    if (input == null) return null;
    if (input.length > maxLength) return "${input.substring(0, maxLength)}...";
    return input;
  }
}
