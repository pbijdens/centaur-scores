import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/participants/participants_view.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  SettingsView({
    super.key,
  });

  static const routeName = '/settings';
  final TextEditingController _urlController = TextEditingController();
  final MatchRepository _repository = MatchRepository();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            drawer: MyApp.drawer(context),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                          child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: FutureBuilder<String>(
                                  future: _repository.getServerURL(),
                                  builder: buildServerURLField,
                                  ))),
                      //
                      Padding(
                          padding: const EdgeInsets.all(4),
                          child: FutureBuilder<String>(
                              future: createSummary(),
                              builder: (context, snapshot) =>
                                  Text(snapshot.data ?? "Loading..."))),
                      //
                      ElevatedButton(
                          onPressed: () {
                            invokeSynchronizeAction(context);
                          },
                          child: const Text("Nu synchroniseren")),
                      ElevatedButton(
                          onPressed: () {
                            invokeDemoDataAction(context);
                          },
                          child: const Text(
                              "Alle scores en deelnemers vervangen door voorbeeld-data")),
                      //
                    ])),
          );
        });
  }

  TextField buildServerURLField(BuildContext context, AsyncSnapshot<String> snapshot) {
    _urlController.text = snapshot.data ?? '';
    return TextField(
        style: StyleHelper
            .participantNameTextStyle(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor:
              Colors.white.withOpacity(0.5),
          hintText: 'Voer een server URL in...',
        ),
        autocorrect: false,
        enableSuggestions: false,
        controller: _urlController,
        onChanged: (value) {
          _repository.setServerURL(value);
        });
  }

  void invokeDemoDataAction(BuildContext context) {
    MatchRepository().demo().then((value) {
      MatchRepository().registerChangeLocally().then((value) {
        Navigator.of(context)
            .popUntil((predicate) => predicate.isFirst);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              const ParticipantsView(),
        ));
      });
    });
  }

  void invokeSynchronizeAction(BuildContext context) {
    MatchRepository()
        .synchronizeWithRemoteSystem()
        .then((value) {
      MatchRepository().loadFromStorage().then((value) {
        MatchRepository().registerChangeLocally().then((value) {
          Navigator.of(context).popUntil(
              (predicate) => predicate.isFirst);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                const ParticipantsView(),
          ));
        });
      });
    });
  }

  Future<String> createSummary() async {
    var model = await MatchRepository().getModel();
    String result =
        'Actieve wedstrijd: ${model.matchCode}: ${model.matchName}\n';
    result += 'Dit apparaat: ${model.deviceID}\n';
    result +=
        'Configuratie: ${model.numberOfEnds} rondes(s) van ${model.arrowsPerEnd} pijl(en)';
    result +=
        ' met ${model.groups.length} discipline(s), ${model.subgroups.length} klasse(s), en ${model.targets.length} blazoen(en)';
    result += ' en ${model.scoreValues.entries.length} toesenbord(en)';

    return result;
  }
}
