import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/scores/scores_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreEntryFullPageWidget extends StatefulWidget {
  static const double formWidth = 480;

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
        participants = event.model.participants.participants;
      });
    }
  }

  bool _isLoading = false;
  List<ParticipantModel> participants = [];
  MatchModel model = MatchModel();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              child: Column(children: [
                Row(children: singeParticipantHeaders()),
                Expanded(
                    flex: 10,
                    child: Row(children: singeParticipantScoreForms())),
                Row(children: singeParticipantSummaries()),
              ]),
            )));
  }

  List<Widget> singeParticipantScoreForms() {
    int index = 0;
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingeParticipantScoreForm(
            model: model, participant: participant, index: index++))
        .toList();
  }

  List<Widget> singeParticipantHeaders() {
    int index = 0;
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingleParticipantHeader(
            model: model, participant: participant, index: index++))
        .toList();
  }

  List<Widget> singeParticipantSummaries() {
    int index = 0;
    return participants
        .where((element) => element.name?.isNotEmpty ?? false)
        .map((participant) => SingeParticipantSummary(
            model: model, participant: participant, index: index++))
        .toList();
  }

  static Color colorForColumn(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade500,
      Colors.red.shade400,
      Colors.yellow.shade500,
      Colors.orange.shade500,
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForColumnFooter(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade100,
      Colors.red.shade100,
      Colors.yellow.shade100,
      Colors.orange.shade100,
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForArrow(MatchModel model, int? arrowValue) {
    if (null == arrowValue) {
      return const Color.fromRGBO(0xEE, 0xEE, 0xEE, 1.0);
    }
    if (arrowValue >= 9) return Colors.yellow.withOpacity(0.25);
    if (arrowValue >= 7) return Colors.red.withOpacity(0.25);
    if (arrowValue >= 5) return Colors.blue.withOpacity(0.25);
    if (arrowValue >= 3) return Colors.black.withOpacity(0.25);
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
  }
}

class SingleParticipantHeader extends StatelessWidget {
  MatchModel model;
  ParticipantModel participant;
  int index;

  SingleParticipantHeader(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    var group = model.groups
            .where((element) => element.code == participant.group)
            .firstOrNull ??
        GroupInfo("Onbekend", "-");
    var subgroup = model.subgroups
            .where((element) => element.code == participant.subgroup)
            .firstOrNull ??
        GroupInfo("Onbekend", "-");

    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: ScoreEntryFullPageWidget.formWidth,
      height: 80,
      child: Container(
          alignment: Alignment.topLeft,
          color: ScoreEntryFullPageWidgetState.colorForColumn(index),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${participant.lijn}: ${participant.name}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text('${group.label} / ${subgroup.label}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.titleLarge)
                  ]))),
    );
  }
}

class SingeParticipantScoreForm extends StatelessWidget {
  MatchModel model;
  ParticipantModel participant;
  int index;

  SingeParticipantScoreForm(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: ScoreEntryFullPageWidget.formWidth,
      child: //SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          //child:
          SizedBox(
              //height: (4.0 + 30.0) * model.ends,
              child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(2),
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: model.arrowsPerEnd + 2,
        scrollDirection: Axis.vertical,
        childAspectRatio: 2,
        children: createScoreRows(context),
      )),
    )
        //)
        ;
  }

  List<Widget> createScoreRows(BuildContext context) {
    List<Widget> result = [];
    for (var endNo = 0; endNo < model.ends; endNo++) {
      result.add(SizedBox(
          height: 20,
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            child: Text('${endNo + 1}',
                style: Theme.of(context).textTheme.titleLarge),
          )));

      int endTotal = 0;
      bool endFilled = false;
      for (var arrowNo = 0; arrowNo < model.arrowsPerEnd; arrowNo++) {
        endFilled =
            endFilled && (participant.ends[endNo].arrows[arrowNo] != null);
        result.add(SizedBox(
            height: 20,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              color: ScoreEntryFullPageWidgetState.colorForArrow(
                  model, participant.ends[endNo].arrows[arrowNo]),
              child: Text('${participant.ends[endNo].arrows[arrowNo] ?? "-"}',
                  style: Theme.of(context).textTheme.titleLarge),
            )));
      }

      result.add(SizedBox(
          height: 20,
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

class SingeParticipantSummary extends StatelessWidget {
  MatchModel model;
  ParticipantModel participant;
  int index;

  SingeParticipantSummary(
      {super.key,
      required this.participant,
      required this.model,
      required this.index});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SizedBox(
      width: ScoreEntryFullPageWidget.formWidth,
      height: 44,
      child: Container(
          color: ScoreEntryFullPageWidgetState.colorForColumnFooter(index),
          child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text('Score: ${participant.score}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge))),
    );
  }
}
