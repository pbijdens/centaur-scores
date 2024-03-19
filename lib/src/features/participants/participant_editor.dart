import 'package:centaur_scores/src/features/participants/participants_viewmodel.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../../model/group_info.dart';
import '../../model/match_model.dart';
import '../../model/participant_model.dart';

class ParticipantEditor extends StatelessWidget {
  final ParticipantsViewmodel viewModel;
  final ParticipantModel participant;
  final MatchModel model;
  final TextEditingController _nameController = TextEditingController();
  final int index;

  ParticipantEditor(
      {super.key,
      required this.participant,
      required this.model,
      required this.viewModel,
      required this.index});

  @override
  Widget build(BuildContext context) {
    _nameController.text = participant.name ?? "";
    return Container(
        color: StyleHelper.colorForScoreForm(index),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              color: StyleHelper.colorForColumn(index),
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Text('Lijn ${participant.lijn}',
                      style: StyleHelper.participantEntryHeading1TextStyle(
                          context)))),
          Padding(
              padding: EdgeInsets.all(4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //
                  children: [
                    spacer(context),
                    Row(children: [
                      formLabel(context, label: 'Naam'),
                      formNameField(context),
                    ]),
                    spacer(context),
                    Row(children: [
                      formLabel(context, label: 'Discipline'),
                      formGroupField(context),
                    ]),
                    spacer(context),
                    Row(children: [
                      formLabel(context, label: 'Klasse'),
                      formSubgroupField(context),
                    ]),
                    spacer(context),
                    Row(children: [
                      formLabel(context, label: 'Blazoen'),
                      formTargetField(context),
                    ]),
                    spacer(context),
                  ]))
        ]));
  }

  Flexible formSubgroupField(BuildContext context) {
    return Flexible(
        child: Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: DropdownButtonFormField<GroupInfo>(
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                hintText: 'Klasse',
              ),
              value: model.subgroups
                  .where((element) => element.code == participant.subgroup)
                  .firstOrNull,
              items: model.subgroups
                  .map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group.label,
                          style:
                              StyleHelper.participantSubgroupDropdownTextStyle(
                                  context))))
                  .toList(),
              onChanged: (value) {
                viewModel.setParticipantSubgroup(
                    participant, value as GroupInfo);
              },
            )));
  }

  Flexible formTargetField(BuildContext context) {
    return Flexible(
        child: Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: DropdownButtonFormField<GroupInfo>(
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                hintText: 'Blazoen',
              ),
              value: model.targets
                  .where((element) => element.code == participant.target)
                  .firstOrNull,
              items: model.targets
                  .map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group.label,
                          style:
                              StyleHelper.participantTargetDropdownTextStyle(
                                  context))))
                  .toList(),
              onChanged: (value) {
                viewModel.setParticipantTarget(
                    participant, value as GroupInfo);
              },
            )));
  }

  Flexible formGroupField(BuildContext context) {
    return Flexible(
        child: Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: DropdownButtonFormField<GroupInfo>(
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                hintText: 'Discipline',
              ),
              value: model.groups
                  .where((element) => element.code == participant.group)
                  .firstOrNull,
              items: model.groups
                  .map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group.label,
                          style: StyleHelper.participantGroupDropdownTextStyle(
                              context))))
                  .toList(),
              onChanged: (value) {
                viewModel.setParticipantGroup(participant, value as GroupInfo);
              },
            )));
  }

  Flexible formNameField(BuildContext context) {
    return Flexible(
        child: Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: TextField(
              style: StyleHelper.participantNameTextStyle(context),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                hintText: 'Voer een naam in...',
              ),
              autocorrect: false,
              enableSuggestions: false,
              controller: _nameController,
              onChanged: (value) {
                viewModel.setParticipantName(participant, value);
              },
            )));
  }

  Widget formLabel(BuildContext context, {required String label}) {
    return SizedBox(
        width: 120,
        child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(label,
                style: StyleHelper.participantEntryLabelTextStyle(context))));
  }

  Widget spacer(BuildContext context) {
    return const SizedBox(height: 10);
  }
}
