import 'package:centaur_scores/src/features/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../../model/participant_model.dart';

typedef GetParticipantFunction = ParticipantModel? Function();
typedef GoToParticipantFunction = void Function();
typedef NewLineFunction = void Function();

class ParticipantNavigationBox extends StatelessWidget {
  final ScoresSingleEndViewmodel _viewModel;
  final GetParticipantFunction getParticipant;
  final GoToParticipantFunction gotoParticipant;
  final NewLineFunction? newline;

  const ParticipantNavigationBox(this._viewModel,
      {required this.getParticipant,
      required this.gotoParticipant,
      this.newline,
      super.key});

  @override
  Widget build(BuildContext context) {
    ParticipantModel? participant = getParticipant.call();

    if (null != participant) {
      return SizedBox(
          height: 400,
          width: 60,
          child: RotatedBox(quarterTurns: 3, child: ElevatedButton(
              onPressed: () {
                gotoParticipant();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: StyleHelper.colorForColumnFooter(
                      _viewModel.columnForParticipant(participant)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)                    
                  ),
                  ),
              child: Container(
                  color: Colors.transparent,
                  child: Text('${participant.name}',
                      style:
                          StyleHelper.endEditorBackButtonTextStyle(context))))));
    } else {
      return SizedBox(
          height: 400,
          width: 60,
          child: RotatedBox(quarterTurns: 3, child: ElevatedButton(
              onPressed: newline,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
              child: Container(
                  color: Colors.transparent,
                  child: (newline == null)
                      ? const Icon(Icons.do_disturb_alt_sharp)
                      : Text('Volgende ronde',
                          style: StyleHelper.endEditorBackButtonTextStyle(
                              context))))));
    }
  }
}
