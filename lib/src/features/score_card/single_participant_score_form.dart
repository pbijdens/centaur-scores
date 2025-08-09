import 'package:centaur_scores/src/model/end_model.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:centaur_scores/src/features/score_card/scores_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../model/match_model.dart';
import '../../model/participant_model.dart';

class SingeParticipantScoreForm extends StatelessWidget {
  final MatchModel _model;
  final ParticipantModel _participant;
  final int _index;
  final Function(BuildContext context, int endNo, int? arrowNo) _onSelect;
  final ScoresViewmodel viewModel;
  final GlobalKey _scrollKey;

  const SingeParticipantScoreForm(
      {super.key,
      required this.viewModel,
      required ParticipantModel participant,
      required MatchModel model,
      required Function(BuildContext context, int endNo, int? arrowNo) onSelect,
      required int index,
      required GlobalKey scrollKey})
      : _index = index,
        _participant = participant,
        _onSelect = onSelect,
        _model = model,
        _scrollKey = scrollKey;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
        color: StyleHelper.colorForScoreForm(_index),
        child: SizedBox(
            width: StyleHelper.scoreCardColumnWidth(context, _model),
            child: SingleChildScrollView(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildScoreRows(context))))));
  }

  List<Widget> buildScoreRows(BuildContext context) {
    List<Widget> result = [];
    int subtotal = 0;
    for (var endNo = 0; endNo < _model.numberOfEnds; endNo++) {
      subtotal += _participant.ends[endNo].score ?? 0;

      result.add(SizedBox(
        width: StyleHelper.scoreCardColumnWidth(context, _model),
        height: StyleHelper.scoreCardRowHeight(context, _model),
        child: InkWell(
            onTap: () {
              onTapScoreField(context, endNo, -1);
            },
            child: Container(
              color: viewModel.activeKeyboard == _index &&
                      viewModel.editingEnd == endNo
                  ? Colors.amber
                  : Colors.transparent,
              child: viewModel.activeKeyboard == _index &&
                      viewModel.editingEnd == endNo
                  ? Row(
                      key: _scrollKey,
                      children: buildScoreRow(
                          context, endNo, _participant.ends[endNo], subtotal))
                  : Row(
                      children: buildScoreRow(
                          context, endNo, _participant.ends[endNo], subtotal)),
            )),
      ));
    }
    return result;
  }

  List<Widget> buildScoreRow(
      BuildContext context, int endNo, EndModel end, int subtotal) {
    List<Widget> result = [];
    int? endscore;

    result.add(SizedBox(
        width: StyleHelper.endNumberWidth,
        height: StyleHelper.preferredCellHeight(context, _model),
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Text('${endNo + 1}',
              style: StyleHelper.scoreFormEndNumberTextStyle(context)),
        )));

    MediaQueryData q = MediaQuery.of(context);
    double inset = q.size.height > 600 ? 4 : 2;

    for (int arrowNo = 0; arrowNo < _model.arrowsPerEnd; arrowNo++) {
      int? arrowScore = _participant.ends[endNo].arrows[arrowNo];
      if (arrowScore != null) {
        endscore ??= 0;
        endscore += arrowScore;
      }
      bool isSelected = viewModel.activeKeyboard == _index &&
          viewModel.editingEnd == endNo &&
          arrowNo == viewModel.editingArrow;
      var box = SizedBox(
          width: StyleHelper.preferredCellWidth(context, _model),
          height: StyleHelper.preferredCellHeight(context, _model),
          child: InkWell(
              onTap: () {
                onTapScoreField(context, endNo, arrowNo);
              },
              child: Container(
                  color: isSelected ? Colors.black : Colors.transparent,
                  child: Padding(
                      padding: isSelected
                          ? EdgeInsets.fromLTRB(inset, inset, inset, inset)
                          : const EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: Container(
                        alignment: Alignment.center,
                        color: isSelected
                            ? StyleHelper.colorForButtonSelected(context)
                            : StyleHelper.colorForButton(context, arrowScore),
                        child: Text('${arrowScore ?? "-"}',
                            style: isSelected
                                ? StyleHelper
                                    .scoreFormArrowScoreTextStyleSelected(
                                        context)
                                : StyleHelper.scoreFormArrowScoreTextStyle(
                                    context, arrowScore)),
                      )))));
      result.add(box);
    }

    // end total
    result.add(SizedBox(
        width: StyleHelper.endTotalWidth,
        height: StyleHelper.preferredCellHeight(context, _model),
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Text('${endscore ?? "-"}',
              style: StyleHelper.scoreFormEndTotalTextStyle(context)),
        )));

    // arrow total
    result.add(SizedBox(
        width: StyleHelper.subTotalWidth,
        height: StyleHelper.preferredCellHeight(context, _model),
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Text('${endscore != null ? subtotal : "-"}',
              style: StyleHelper.scoreFormEndTotalTextStyle(context)),
        )));

    return result;
  }

  // Opens the score entry on the field that was tapped. If a summary field is
  // tapped, open the editor on the first field.
  void onTapScoreField(BuildContext context, int endNo, int arrowNo) {
    _onSelect(context, endNo,
        arrowNo < 0 || arrowNo >= _model.arrowsPerEnd ? null : arrowNo);
  }
}
