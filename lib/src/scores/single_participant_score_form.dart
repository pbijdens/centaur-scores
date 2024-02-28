import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/score_entry/score_entry_single_end.dart';
import 'package:centaur_scores/src/scores/score_form_helper.dart';
import 'package:centaur_scores/src/scores/scores_viewmodel.dart';
import 'package:flutter/material.dart';

class SingeParticipantScoreForm extends StatelessWidget {
  MatchModel _model;
  ParticipantModel _participant;
  int _index;

  final ScoresViewmodel viewModel;

  SingeParticipantScoreForm(
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
      color: ScoreFormHelper.colorForScoreForm(_index),
      child: SizedBox(
          width: ScoreFormHelper.scoreCardColumnWidth(_model),
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(1),
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            crossAxisCount: _model.arrowsPerEnd + 2,
            scrollDirection: Axis.vertical,
            childAspectRatio: ScoreFormHelper.childAspectRatio(_model),
            children: createScoreRows(context),
          )),
    );
  }

  List<Widget> createScoreRows(BuildContext context) {
    List<Widget> result = [];
    for (var endNo = 0; endNo < _model.ends; endNo++) {
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
                style: Theme.of(context).textTheme.titleLarge),
          )));

      int endTotal = 0;
      bool endFilled = true;
      for (var arrowNo = 0; arrowNo < _model.arrowsPerEnd; arrowNo++) {
        int? arrowScore = _participant.ends[endNo].arrows[arrowNo];
        endFilled = endFilled && (arrowScore != null);
        endTotal += arrowScore ?? 0;
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
              padding: const EdgeInsets.all(8),
              color: ScoreFormHelper.colorForArrow(_model, arrowScore),
              child: Text('${arrowScore ?? "-"}',
                  style: Theme.of(context).textTheme.titleLarge),
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
            child: Text('${endFilled ? endTotal : "-"}',
                style: Theme.of(context).textTheme.titleLarge),
          )));
    }
    return result;
  }
}
