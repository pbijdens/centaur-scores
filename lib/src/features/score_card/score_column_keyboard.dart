import 'package:centaur_scores/src/features/score_card/scores_viewmodel.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../../model/match_model.dart';
import '../../model/participant_model.dart';
import '../../model/score_button_definition.dart';

class ScoreColumnKeyboard extends StatelessWidget {
  final ScoresViewmodel _viewModel;
  final MatchModel _model;
  final ParticipantModel _participant;

  const ScoreColumnKeyboard(this._viewModel, this._model, this._participant,
      {super.key});

  @override
  Widget build(BuildContext context) {
    //MediaQueryData q = MediaQuery.of(context);
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.transparent),
            color: StyleHelper.colorForColumnFooter(
                _viewModel.activeKeyboard ?? 0)),
        child: SizedBox(
            width: StyleHelper.scoreCardColumnWidth(context, _model),
            child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(children: buildRows(context)))));
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> result = [];
    List<Widget> currentRow = [];

    List<ScoreButtonDefinition> keys = [];

    String? mostRelevantKeyboard = _model.scoreValues.keys
        .where((element) => element
            .split(',')
            .map((e) => e.trim())
            .contains(_participant.target))
        .lastOrNull;
    if (mostRelevantKeyboard == null) {
      keys = _model.scoreValues.entries.firstOrNull?.value ?? [];
    } else {
      keys = _model.scoreValues[mostRelevantKeyboard] ?? [];
    }

    int buttonsPerRow = keys.length > 7 ? 4 : 3;

    var rowHeight = StyleHelper.keyboardButtonRowHeight(
        context, _model, buttonsPerRow, keys);

    for (int i = 0; i < keys.length; i++) {
      currentRow.add(Expanded(
          child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ElevatedButton(
                onPressed: () {
                  _viewModel.setScore(keys[i].value, _model, _participant);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // remove default padding
                  backgroundColor:
                      StyleHelper.colorForButton(context, keys[i].value),
                  foregroundColor:
                      StyleHelper.colorForButtonLabel(context, keys[i].value),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Container(
                  height: rowHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      keys[i].label,
                      style: StyleHelper.keypadTextStyleSmall(
                        context,
                        keys[i].label,
                      )?.apply(
                        color: StyleHelper.colorForButtonLabel(
                            context, keys[i].value),
                      ),
                    ),
                  ),
                ),
              ))));
      if (currentRow.length == buttonsPerRow) {
        result.add(Container(
            height: rowHeight,
            color: Colors.transparent,
            child: Row(children: currentRow)));
        currentRow = [];
      }
    }
    if (currentRow.isNotEmpty) {
      result.add(Container(
          color: Colors.transparent, child: Row(children: currentRow)));
    }

    return result;
  }
}
