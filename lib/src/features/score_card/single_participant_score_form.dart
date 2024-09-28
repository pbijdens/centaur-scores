import 'package:centaur_scores/src/features/score_entry/score_entry_single_end.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:centaur_scores/src/features/score_card/scores_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../model/match_model.dart';
import '../../model/participant_model.dart';

class SingeParticipantScoreForm extends StatelessWidget {
  final MatchModel _model;
  final ParticipantModel _participant;
  final int _index;

  final ScoresViewmodel viewModel;

  const SingeParticipantScoreForm(
      {super.key,
      required this.viewModel,
      required ParticipantModel participant,
      required MatchModel model,
      required int index})
      : _index = index,
        _participant = participant,
        _model = model;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      color: StyleHelper.colorForScoreForm(_index),
      child: SizedBox(
          width: StyleHelper.scoreCardColumnWidth(_model),
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(1),
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            crossAxisCount: _model.arrowsPerEnd + 2,
            scrollDirection: Axis.vertical,
            childAspectRatio: StyleHelper.childAspectRatio(_model),
            children: createScoreRows(context),
          )),
    );
  }

  List<Widget> createScoreRows(BuildContext context) {
    List<Widget> result = [];
    for (var endNo = 0; endNo < _model.numberOfEnds; endNo++) {
      result.add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        ScoreEntryForSingleEndView(
                            lijnNo: _index,
                            endNo: endNo,
                            arrowNo: -1))).then((value) {
              viewModel.notifyViewmodelUpdated();
            });
          },
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            child: Text('${endNo + 1}',
                style: StyleHelper.scoreFormEndNumberTextStyle(context)),
          )));

      for (var arrowNo = 0; arrowNo < _model.arrowsPerEnd; arrowNo++) {
        int? arrowScore = _participant.ends[endNo].arrows[arrowNo];
        result.add(InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          ScoreEntryForSingleEndView(
                              lijnNo: _index,
                              endNo: endNo,
                              arrowNo: arrowNo))).then((value) {
                viewModel.notifyViewmodelUpdated();
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: StyleHelper.colorForArrow(arrowScore),
                  ),
                  color: StyleHelper.colorForArrow(arrowScore),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Text('${arrowScore ?? "-"}',
                  style: StyleHelper.scoreFormArrowScoreTextStyle(
                      context, arrowScore)),
            )));
      }

      result.add(InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        ScoreEntryForSingleEndView(
                            lijnNo: _index,
                            endNo: endNo,
                            arrowNo: -1))).then((value) {
              viewModel.notifyViewmodelUpdated();
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Text('${_participant.ends[endNo].score ?? "-"}',
                style: StyleHelper.scoreFormEndTotalTextStyle(context)),
          )));
    }
    return result;
  }
}
