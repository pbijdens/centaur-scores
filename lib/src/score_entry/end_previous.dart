import 'package:centaur_scores/src/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../model/match_model.dart';
import '../model/participant_model.dart';

class ScoreViewPreviousEnd extends StatelessWidget {
  final ScoresSingleEndViewmodel _viewModel;
  final MatchModel _model;
  final ParticipantModel _participant;

  const ScoreViewPreviousEnd(this._viewModel, this._model, this._participant,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (_viewModel.endNo > 0) {
      return InkWell(
          onTap: () {
            _viewModel.previousEnd();
          },
          child: SizedBox(
              width: StyleHelper.scoreCardColumnWidth(_model),
              height: StyleHelper.preferredCellHeight,
              child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                      color: StyleHelper.colorForScoreForm(_viewModel.lijnNo),
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(1),
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        crossAxisCount: _model.arrowsPerEnd + 2,
                        scrollDirection: Axis.vertical,
                        childAspectRatio:
                            StyleHelper.childAspectRatioForEditor(_model),
                        children: createScoreRows(context),
                      )))));
    }
    return SizedBox(
        height: StyleHelper.preferredCellHeight,
        width: StyleHelper.scoreCardColumnWidth(_model),
        child: Container(
            color: Colors.white70,
            child: Align(
                alignment: Alignment.center,
                child: Text('Eerste ronde',
                    style: StyleHelper.noMoreEndsTextStyle(context)))));
  }

  List<Widget> createScoreRows(BuildContext context) {
    int endNo = _viewModel.endNo - 1;

    List<Widget> result = [];
    result.add(Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(8),
      color: Colors.transparent,
      child: Text('${endNo + 1}',
          style: StyleHelper.nextPrevEndEndNoTextStyle(context)),
    ));

    int endTotal = 0;
    bool endFilled = true;
    for (var arrowNo = 0; arrowNo < _model.arrowsPerEnd; arrowNo++) {
      if (_participant.ends.length > endNo) {
        int? arrowScore = _participant.ends[endNo].arrows[arrowNo];
        endFilled = endFilled && (arrowScore != null);
        endTotal += arrowScore ?? 0;

        result.add(Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 4.0),
              color: Colors.black12),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4),
          child: Text('${arrowScore ?? "-"}',
              style: StyleHelper.nextPrevEndArrowScoreTextStyle(context)),
        ));
      } else {
        result.add(const Text('Laden...'));
      }
    }

    result.add(Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Text('${endFilled ? endTotal : "-"}',
          style: StyleHelper.nextPrevEndEndScoreTextStyle(context)),
    ));

    return result;
  }
}
