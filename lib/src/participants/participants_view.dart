import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/participants/participants_viewmodel.dart';
import 'package:centaur_scores/src/scores/score_entry_fullpage_widget.dart';
import 'package:centaur_scores/src/scores/scores_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'participant_editor.dart';

class ParticipantsView extends StatelessWidget {
  const ParticipantsView({super.key});

  static const routeName = '/participants';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.participantScreenTitle),
        ),
        drawer: MyApp.drawer(context),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ScoresView(),
                  ));
            },
            label: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Scores Invoeren", textAlign: TextAlign.center)),
            icon: const Icon(Icons.edit)),
        body: Container(margin: EdgeInsets.all(20), child: ParticipantsForm()));
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
  List<ParticipantModel> participants = [];
  MatchModel model = MatchModel();

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
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return ParticipantListItem(
              viewModel: _viewModel,
              participant: participants[index],
              model: model);
        },
      ),
    );
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
        participants = event.model.participants.participants;
      });
    } else if (event is ParticipantPropertyChangedEvent) {
      // setState(() {
      //   // model.participants.updateParticipant(event.participant.id, event.participant);
      // });
    }
  }
}
