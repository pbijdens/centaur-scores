import 'package:centaur_scores/src/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../model/match_model.dart';
import '../model/participant_model.dart';
import '../model/score_button_definition.dart';

class ScoreKeyboard extends StatelessWidget {
  final ScoresSingleEndViewmodel _viewModel;
  final MatchModel _model;
  final ParticipantModel _participant;

  const ScoreKeyboard(this._viewModel, this._model, this._participant,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: StyleHelper.colorForColumnFooter(_viewModel.lijnNo),
        child: SizedBox(
            width: StyleHelper.scoreCardColumnWidth(_model),
            child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(children: buildRows(context)))));
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> result = [];
    List<Widget> currentRow = [];

    List<ScoreButtonDefinition> keys = [];

    String? mostRelevantKeyboard = _model.scoreValues.keys
        .where((element) => element.split(',').map((e) => e.trim()).contains(_participant.target))
        .lastOrNull;
    if (mostRelevantKeyboard == null) {
      keys = _model.scoreValues.entries.firstOrNull?.value ?? [];
    } else {
      keys = _model.scoreValues[mostRelevantKeyboard] ?? [];
    }

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
                        StyleHelper.colorForButton(_model, keys[i].value),
                    foregroundColor:
                        StyleHelper.colorForButtonLabel(_model, keys[i].value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: SizedBox(
                    height: 75,
                    child: Align(
                        alignment: Alignment.center,
                        child: (keys[i].value == null)
                            ? Text(keys[i].label,
                                style: StyleHelper.keypadTextStyle(context))
                            : Text(keys[i].label,
                                style: StyleHelper.keypadTextStyle(context)
                                    ?.apply(
                                        color: StyleHelper.colorForButtonLabel(
                                            _model, keys[i].value)))),
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
