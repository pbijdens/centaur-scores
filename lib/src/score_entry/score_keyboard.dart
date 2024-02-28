import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:flutter/material.dart';

class ScoreKeyboard extends StatelessWidget {
  final ScoresSingleEndViewmodel _viewModel;
  final MatchModel _model;
  final ParticipantModel _participant;

  const ScoreKeyboard(this._viewModel, this._model, this._participant,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ScoreFormHelper.colorForColumnFooter(_viewModel.lijnNo),
        child: SizedBox(
            width: ScoreFormHelper.scoreCardColumnWidth(_model),
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(children: buildRows(context)))));
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> result = [];
    List<Widget> currentRow = [];

    List<ScoreButton> keys = _model.scoreValues[_participant.group] ?? [];

    int buttonsPerRow = keys.length > 7 ? 4 : 3;

    for (int i = 0; i < keys.length; i++) {
      currentRow.add(Expanded(
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                  onPressed: () {
                    _viewModel.setScore(keys[i].value);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ScoreFormHelper.colorForButton(_model, keys[i].value),
                    foregroundColor: ScoreFormHelper.colorForButtonLabel(
                        _model, keys[i].value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: SizedBox(
                    height: 65,
                    child: Align(
                        alignment: Alignment.center,
                        child: keys[i].value == null
                            ? Text(keys[i].label ?? '!DEL!')
                            : Text(keys[i].label ?? '')),
                  )))));
      if (currentRow.length == buttonsPerRow) {
        result.add(Row(children: currentRow));
        currentRow = [];
      }
    }
    if (currentRow.isNotEmpty) {
      result.add(Row(children: currentRow));
    }

    return result;
  }
}
