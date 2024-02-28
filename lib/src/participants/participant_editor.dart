import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/participants/participants_viewmodel.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

class ParticipantListItem extends StatelessWidget {
  final ParticipantsViewmodel viewModel;
  final ParticipantModel participant;
  final MatchModel model;
  final TextEditingController _nameController = TextEditingController();

  ParticipantListItem(
      {super.key,
      required this.participant,
      required this.model,
      required this.viewModel});

  @override
  Widget build(BuildContext context) {
    _nameController.text = participant.name ?? "";

    return Row(children: [
      Expanded(
        flex: 0,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              participant.lijn,
              maxLines: 1,
              style: StyleHelper.participantLijnTextStyle(context),
            )),
      ),
      Expanded(
        flex: 2,
        child: TextField(
          decoration: InputDecoration(
            hintText:
                'Klik om de naam voor de schutter op lijn ${participant.lijn} in te voeren',
          ),
          autocorrect: false,
          controller: _nameController,
          onChanged: (value) {
            viewModel.setParticipantName(participant, value);
          },
        ),
      ),
      Expanded(
          flex: 1,
          child: DropdownButtonFormField<GroupInfo>(
            hint: Text('Discipline (${model.groups.length})'),
            value: model.groups
                .where((element) => element.code == participant.group)
                .firstOrNull,
            items: model.groups
                .map((group) => DropdownMenuItem(
                    value: group,
                    child: Text(group.label ?? "",
                        style: StyleHelper.participantGroupDropdownTextStyle(
                            context))))
                .toList(),
            onChanged: (value) {
              viewModel.setParticipantGroup(participant, value as GroupInfo);
            },
          )),
      Expanded(
          flex: 1,
          child: DropdownButtonFormField<GroupInfo>(
            hint: const Text('Groep'),
            value: model.subgroups
                .where((element) => element.code == participant.subgroup)
                .firstOrNull,
            items: model.subgroups
                .map((group) => DropdownMenuItem(
                    value: group,
                    child: Text(group.label ?? "",
                        style: StyleHelper.participantSubgroupDropdownTextStyle(
                            context))))
                .toList(),
            onChanged: (value) {
              viewModel.setParticipantSubgroup(participant, value as GroupInfo);
            },
          )),
    ]);
  }
}
