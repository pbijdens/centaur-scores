import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/scores/scores_viewmodel.dart';
import 'package:centaur_scores/src/scores/single_participant_footer.dart';
import 'package:centaur_scores/src/scores/single_participant_header_line_two.dart';
import 'package:centaur_scores/src/scores/single_participant_header_line_one.dart';
import 'package:centaur_scores/src/scores/single_participant_score_form.dart';
import 'package:centaur_scores/src/style/loading_screen.dart';
import 'package:flutter/material.dart';

import '../model/match_model.dart';
import '../model/participant_model.dart';

class ScoreEntryFullPageWidget extends StatefulWidget {
  const ScoreEntryFullPageWidget({super.key});

  @override
  ScoreEntryFullPageWidgetState createState() {
    return ScoreEntryFullPageWidgetState();
  }
}

class ScoreEntryFullPageWidgetState extends State<ScoreEntryFullPageWidget>
    implements EventObserver {
  final _formKey = GlobalKey<FormState>();
  final ScoresViewmodel _viewModel = ScoresViewmodel(MatchRepository());

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

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is ScoresViewmodelLoadedEvent) {
      setState(() {
        model = event.model;
        participants = event.model.participants;
      });
    } else if (event is ScoresViewmodelUpdatedEvent) {
      setState(() {});
    }
  }

  bool _isLoading = false;
  List<ParticipantModel> participants = [];
  MatchModel model = MatchModel();

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen();
    }
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              child: Column(children: [
                IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: singeParticipantDisciplines())),
                IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: singeParticipantNames())),
                Expanded(
                    flex: 10,
                    child: Row(children: singeParticipantScoreForms())),
                IntrinsicHeight(
                    child: Row(children: singeParticipantSummaries())),
              ]),
            )));
  }

  List<Widget> singeParticipantScoreForms() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingeParticipantScoreForm(
            viewModel: _viewModel,
            model: model,
            participant: participant,
            index: participants.indexWhere((e) => e.id == participant.id)))
        .toList();
  }

  List<Widget> singeParticipantNames() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingleParticipantHeaderLineOne(
            model: model, participant: participant, index: participants.indexWhere((e) => e.id == participant.id)))
        .toList();
  }

  List<Widget> singeParticipantDisciplines() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingleParticipantHeaderLineTwo(
            model: model, participant: participant, index: participants.indexWhere((e) => e.id == participant.id)))
        .toList();
  }

  List<Widget> singeParticipantSummaries() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingeParticipantFooter(
            model: model, participant: participant, index: participants.indexWhere((e) => e.id == participant.id)))
        .toList();
  }
}
