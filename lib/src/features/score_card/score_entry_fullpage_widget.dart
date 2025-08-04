import 'package:centaur_scores/src/features/score_card/score_column_keyboard.dart';
import 'package:centaur_scores/src/features/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/features/score_card/scores_viewmodel.dart';
import 'package:centaur_scores/src/features/score_card/single_participant_footer.dart';
import 'package:centaur_scores/src/features/score_card/single_participant_header_line_two.dart';
import 'package:centaur_scores/src/features/score_card/single_participant_header_line_one.dart';
import 'package:centaur_scores/src/features/score_card/single_participant_score_form.dart';
import 'package:centaur_scores/src/style/loading_screen.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

import '../../model/match_model.dart';
import '../../model/participant_model.dart';

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
      debugPrint("ScoresViewmodelLoadedEvent - loaded scores viewmodel");
      setState(() {
        model = event.model;
        participants = event.model.participants;
      });
    } else if (event is ScoresViewmodelUpdatedEvent) {
      debugPrint("ScoresViewmodelUpdatedEvent - scores viewmodel was updated");
      setState(() {});
    } else if (event is ArrowStateChangedEvent) {
      debugPrint(
          "ArrowStateChangedEvent - arrow state changed for a single arrow");
      setState(() {});
    } else if (event is KeyboardShownEvent) {
      debugPrint("KeyboardShownEvent - showing keyboard");
      //setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _keyboardScrollKey.currentContext;
        if (context != null) {
          debugPrint("KeyboardShownEvent - scrolling keyboard into view");
          Scrollable.ensureVisible(context,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }
      });
    } else if (event is ActiveArrowChangedEvent) {
      debugPrint("ActiveArrowChangedEvent - active arrow changed");
      //setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _scrollKey.currentContext;
        if (context != null) {
          debugPrint(
              "ActiveArrowChangedEvent - scrolling arrow selection into view");
          Scrollable.ensureVisible(context,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }
      });
    }
  }

  bool _isLoading = false;
  List<ParticipantModel> participants = [];
  MatchModel model = MatchModel();
  final GlobalKey _scrollKey = GlobalKey();
  final GlobalKey _keyboardScrollKey = GlobalKey();

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
                        children: singeParticipantNames())),
                Expanded(
                    flex: 10,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(children: singeParticipantScoreForms()))),
                IntrinsicHeight(
                    child: Row(children: singeParticipantSummaries()))
              ]),
            )));
  }

  List<Widget> singeParticipantScoreForms() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => Column(children: [
              Expanded(
                  flex: 10,
                  child: SingeParticipantScoreForm(
                      scrollKey: _scrollKey,
                      viewModel: _viewModel,
                      model: model,
                      participant: participant,
                      onSelect: (BuildContext currentContext, int endNo,
                          int? arrowNo) {
                        int activeKeyboard = participants
                            .indexWhere((e) => e.id == participant.id);
                        _viewModel.activateKeyboard(
                            model,
                            activeKeyboard >= 0 ? activeKeyboard : null,
                            endNo,
                            arrowNo);
                      },
                      index: participants
                          .indexWhere((e) => e.id == participant.id))),
              keyboard(context, model, participant,
                  participants.indexWhere((e) => e.id == participant.id))
            ]))
        .toList();
  }

  List<Widget> singeParticipantNames() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingleParticipantHeaderLineOne(
            model: model,
            participant: participant,
            index: participants.indexWhere((e) => e.id == participant.id)))
        .toList();
  }

  List<Widget> singeParticipantDisciplines() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingleParticipantHeaderLineTwo(
            model: model,
            participant: participant,
            index: participants.indexWhere((e) => e.id == participant.id)))
        .toList();
  }

  List<Widget> singeParticipantSummaries() {
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => Column(children: [
              SingeParticipantFooter(
                  model: model,
                  participant: participant,
                  index: participants.indexWhere((e) => e.id == participant.id))
            ]))
        .toList();
  }

  Widget keyboard(BuildContext context, MatchModel model,
      ParticipantModel participantModel, int participantIndex) {
    if (participantIndex == _viewModel.activeKeyboard) {
      return IntrinsicHeight(
          key: _keyboardScrollKey,
          child: ScoreColumnKeyboard(_viewModel, model, participantModel));
    }
    return SizedBox(
      width: StyleHelper.scoreCardColumnWidth(context, model),
      height: 0,
      child: Container(color: Colors.transparent),
    );
  }
}
