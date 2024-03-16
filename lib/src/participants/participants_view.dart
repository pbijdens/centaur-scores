import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/participants/participants_viewmodel.dart';
import 'package:centaur_scores/src/scores/scores_view.dart';
import 'package:centaur_scores/src/style/loading_screen.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:centaur_scores/src/syncwidget/score_sync_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/match_model.dart';
import 'participant_editor.dart';

class ParticipantsView extends StatelessWidget {
  const ParticipantsView({super.key});

  static const routeName = '/participants';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              appBar: AppBar(
                title:
                    Row(children: [ScoreSyncWidget(), Text(AppLocalizations.of(context)!.participantScreenTitle)]),
              ),
              drawer: MyApp.drawer(context),
              floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const ScoresView(),
                        ));
                  },
                  label: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Scores Invoeren",
                          textAlign: TextAlign.center,
                          style: StyleHelper.endEditorBackButtonTextStyle(
                              context))),
                  icon: const Icon(Icons.edit)),
              body: Container(
                  margin: const EdgeInsets.all(20),
                  child: const ParticipantsForm())
              //
              );
        });
  }
}

class ParticipantsForm extends StatefulWidget {
  const ParticipantsForm({super.key});

  @override
  ParticipantsFormState createState() {
    return ParticipantsFormState();
  }
}

class ParticipantsFormState extends State<ParticipantsForm>
    implements EventObserver {
  final _formKey = GlobalKey<FormState>();

  final ParticipantsViewmodel _viewModel =
      ParticipantsViewmodel(MatchRepository());

  bool _isLoading = false;
  MatchModel model = MatchModel();

  ParticipantsFormState();

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen();
    }
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Align(
            alignment: Alignment.topCenter,
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),                      
                      //
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: createForms(context),
                      )));
            })));
  }

  List<Widget> createForms(BuildContext context) {
    List<Widget> result = [];
    for (int index = 0; index < model.participants.length; index++) {
      result.add(ParticipantEditor(
          viewModel: _viewModel,
          participant: model.participants[index],
          index: index,
          model: model));
    }
    return result;
  }

  @override
  void notify(ViewEvent event) {
    if (event is LoadingEvent) {
      setState(() {
        _isLoading = event.isLoading;
      });
    } else if (event is ParticipantsViewmodelLoadedEvent) {
      setState(() {
        model = event.model;
      });
    }
  }
}
