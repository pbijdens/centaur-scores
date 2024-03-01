import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/participants/participants_viewmodel.dart';
import 'package:centaur_scores/src/scores/scores_view.dart';
import 'package:centaur_scores/src/style/loading_screen.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/match_model.dart';
import 'participant_editor.dart';

class ParticipantsView extends StatelessWidget {
  ParticipantsView({super.key});

  static const routeName = '/participants';

  final ParticipantsViewmodel _viewModel =
      ParticipantsViewmodel(MatchRepository());

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              appBar: AppBar(
                title:
                    Text(AppLocalizations.of(context)!.participantScreenTitle),
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
                  child: ParticipantsForm(_viewModel))
              //
              );
        });
  }
}

class ParticipantsForm extends StatefulWidget {
  const ParticipantsForm(this._viewmodel, {super.key});

  final ParticipantsViewmodel _viewmodel;

  @override
  ParticipantsFormState createState() {
    return ParticipantsFormState(_viewmodel);
  }
}

class ParticipantsFormState extends State<ParticipantsForm>
    implements EventObserver {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  MatchModel model = MatchModel();
  final ParticipantsViewmodel _viewModel;

  ParticipantsFormState(this._viewModel);

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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen();
    }
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: createForms(context),
                    )))));
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
