import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:flutter/material.dart';

class ScoreInputThisEnd extends StatelessWidget {
  final ScoresSingleEndViewmodel _viewModel;
  final MatchModel _model;
  final ParticipantModel _participant;
  final int _highlightedArrowNo;

  ScoreInputThisEnd(
      this._viewModel, this._model, this._participant, this._highlightedArrowNo,
      {super.key}) {
    if (_highlightedArrowNo < 0 ||
        _highlightedArrowNo >= _model.arrowsPerEnd && _viewModel.endNo < _participant.ends.length) {          
          int hlArrow = _viewModel.participant?.ends[_viewModel.endNo].arrows.indexWhere((element) => element != null) ?? 0;
          _viewModel.hilightCell(_viewModel.endNo, hlArrow < 0 ? 0 : hlArrow);
        }        
      }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ScoreFormHelper.scoreCardColumnWidth(_model),
        height: ScoreFormHelper.preferredCellHeight + 4,
        child: Container(
            color: ScoreFormHelper.colorForScoreForm(_viewModel.lijnNo),
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(4),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: _model.arrowsPerEnd + 2,
              scrollDirection: Axis.vertical,
              childAspectRatio:
                  ScoreFormHelper.childAspectRatioForEditor(_model),
              children: createScoreRows(context),
            )));
  }

  List<Widget> createScoreRows(BuildContext context) {
    List<Widget> result = [];
    for (var endNo = _viewModel.endNo; endNo <= _viewModel.endNo; endNo++) {
      result.add(Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8),
        color: ScoreFormHelper.colorForEditRow(),
        child:
            Text('${endNo + 1}', style: Theme.of(context).textTheme.titleLarge),
      ));

      int endTotal = 0;
      bool endFilled = true;
      for (var arrowNo = 0; arrowNo < _model.arrowsPerEnd; arrowNo++) {
        if (_participant.ends.length > endNo) {
          int? arrowScore = _participant.ends[endNo].arrows[arrowNo];
          endFilled = endFilled && (arrowScore != null);
          endTotal += arrowScore ?? 0;

          result.add(InkWell(
              onTap: () {
                _viewModel.hilightCell(endNo, arrowNo);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: _highlightedArrowNo != arrowNo
                        ? Border.all(color: Colors.transparent, width: 4.0)
                        : Border.all(
                            color: ScoreFormHelper.colorForCellBorder(
                                _viewModel.lijnNo),
                            width: 4.0),
                    color: ScoreFormHelper.colorForEditRow()),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: Text('${arrowScore ?? "-"}',
                    style: Theme.of(context).textTheme.titleLarge),
              )));
        } else {
          result.add(const Text('Laden...'));
        }
      }

      result.add(Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        color: ScoreFormHelper.colorForEditRow(),
        child: Text('${endFilled ? endTotal : "-"}',
            style: Theme.of(context).textTheme.titleLarge),
      ));
    }
    return result;
  }
}
