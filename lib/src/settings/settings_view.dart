import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/participants/participants_view.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
  });

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: FutureBuilder<String>(
                              future: createSummary(),
                              builder: (context, snapshot) =>
                                  Text(snapshot.data ?? "Loading..."))),
                      //
                      ElevatedButton(
                          onPressed: () {
                            MatchRepository().load().then((value) {
                              MatchRepository().save().then((value) {
                                Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ParticipantsView(),
                                    ));
                              });
                            });
                          },
                          child: const Text("Synchroniseer met de server")),
                      ElevatedButton(
                          onPressed: () {
                            MatchRepository().demo().then((value) {
                              MatchRepository().save().then((value) {
                                Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ParticipantsView(),
                                    ));
                              });
                            });
                          },
                          child: const Text("Replace contents with demo data")),
                      //
                    ])),
          );
        });
  }

  Future<String> createSummary() async {
    var model = await MatchRepository().getModel();
    String result =
        "${model.wedstrijdCode}: ${model.wedstrijdNaam}\nRondes: ${model.ends}; Pijlen: ${model.arrowsPerEnd}, ID: ${model.deviceID}\n";
    result +=
        '\nDisciplines: ${model.groups.map((e) => '${e.code}: ${e.label}').join(', ')}';
    result +=
        '\nKlasses: ${model.subgroups.map((e) => '${e.code}: ${e.label}').join(', ')}';
    result += '\nToetsenborden:\n';
    for (var keyboard in model.scoreValues.entries) {
      result +=
          '${keyboard.key}:${keyboard.value.map((e) => '${e.label}=${e.value}').join(', ')}\n';
    }
    result += '\n';
    for (var participant in model.participants) {
      result +=
          'Lijn ${participant.lijn}: ${participant.name ?? "n/a"}, ${participant.group}, ${participant.subgroup} (score: ${participant.score})\n';
    }

    return result;
  }
}
