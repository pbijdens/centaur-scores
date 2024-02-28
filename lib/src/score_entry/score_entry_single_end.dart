import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/score_entry/end_next.dart';
import 'package:centaur_scores/src/score_entry/end_previous.dart';
import 'package:centaur_scores/src/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/style/loading_screen.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'score_keyboard.dart';
import 'end_this.dart';

class ScoreEntryForSingleEndView extends StatelessWidget {
  final int arrowNo;
  final int endNo;
  final int lijnNo;

  ScoreEntryForSingleEndView(
      {required this.endNo,
      required this.lijnNo,
      required this.arrowNo,
      super.key});

  static const routeName = '/scores/single-end';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.singleEndScreenTitle),
        ),
        drawer: MyApp.drawer(context),
        backgroundColor: Colors.white38,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            label: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Terug",
                    textAlign: TextAlign.center,
                    style: StyleHelper.endEditorBackButtonTextStyle(context))),
            icon: const Icon(Icons.arrow_back)),
        body: Container(
            margin: const EdgeInsets.all(0),
            child: ScoreEntryForSingleEndViewForm(
                endNo: endNo, lijnNo: lijnNo, arrowNo: arrowNo)));
  }
}

class ScoreEntryForSingleEndViewForm extends StatefulWidget {
  const ScoreEntryForSingleEndViewForm(
      {required this.endNo,
      required this.lijnNo,
      required this.arrowNo,
      super.key});

  final int arrowNo;
  final int endNo;
  final int lijnNo;

  @override
  SingleEndPage createState() {
    // ignore: no_logic_in_create_state
    return SingleEndPage(
        ScoresSingleEndViewmodel(MatchRepository(), lijnNo, endNo, arrowNo));
  }
}

class SingleEndPage extends State<ScoreEntryForSingleEndViewForm>
    implements EventObserver {
  final ScoresSingleEndViewmodel _viewModel;

  bool _isLoading = false;

  SingleEndPage(this._viewModel);

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModel.load();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  MatchModel? _model;
  MatchModel get model => _model ?? MatchModel();

  // int _highlightedArrowNo = -1;

  ParticipantModel? _participant;
  ParticipantModel get participant =>
      _participant ?? ParticipantModel(lijn: "-", id: 0);

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is SingleEndViewmodelLoadedEvent) {
      setState(() {
        _model = event.model;
      });
    } else if (event is ParticipantChangedEvent) {
      setState(() {
        _participant = event.participant;
      });
    } else if (event is ArrowStateChangedEvent) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen();
    }
    var group = model.groups
            .where((element) => element.code == participant.group)
            .firstOrNull ??
        GroupInfo("Onbekend", "-");
    var subgroup = model.subgroups
            .where((element) => element.code == participant.subgroup)
            .firstOrNull ??
        GroupInfo("Onbekend", "-");

    return Container(
        alignment: Alignment.center,
        child: Column(children: [
          headerLineOne(context, group, subgroup),
          headerLineTwo(context),
          ScoreViewPreviousEnd(_viewModel, model, participant),
          ScoreInputThisEnd(_viewModel, model, participant, _viewModel.arrowNo),
          ScoreViewNextEnd(_viewModel, model, participant),
          ScoreKeyboard(_viewModel, model, participant)
        ]));
  }

  SizedBox headerLineOne(
      BuildContext context, GroupInfo group, GroupInfo subgroup) {
    return SizedBox(
      width: StyleHelper.scoreCardColumnWidth(model),
      child: Container(
          alignment: Alignment.topLeft,
          color: StyleHelper.colorForColumnFooter(_viewModel.lijnNo),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: RichText(
                        text: TextSpan(
                  text: '',
                  style: StyleHelper.endEditorTopHeaderTextStyle(context),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Lijn: ',
                        style: StyleHelper.endEditorTopHeaderBoldTextStyle(
                            context)),
                    TextSpan(text: participant.lijn),
                  ],
                ))),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: StyleHelper.endEditorTopHeaderTextStyle(context),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Klasse: ',
                          style: StyleHelper.endEditorTopHeaderBoldTextStyle(
                              context)),
                      TextSpan(text: group.label),
                      TextSpan(
                          text: ' / ',
                          style: StyleHelper.endEditorTopHeaderBoldTextStyle(
                              context)),
                      TextSpan(text: subgroup.label),
                    ],
                  ),
                )
              ]))),
    );
  }

  SizedBox headerLineTwo(BuildContext context) {
    return SizedBox(
      width: StyleHelper.scoreCardColumnWidth(model),
      child: Container(
          alignment: Alignment.topLeft,
          color: StyleHelper.colorForColumn(_viewModel.lijnNo),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(participant.name ?? "-",
                        textAlign: TextAlign.left,
                        style: StyleHelper.editorParticipantNameHeader(context)),
                  ]))),
    );
  }
}
