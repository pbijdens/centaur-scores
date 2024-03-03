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
                                Navigator.of(context)
                                    .popUntil((predicate) => predicate.isFirst);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      ParticipantsView(),
                                ));
                              });
                            });
                          },
                          child: const Text("Nu synchroniseren")),
                      ElevatedButton(
                          onPressed: () {
                            MatchRepository().demo().then((value) {
                              MatchRepository().save().then((value) {
                                Navigator.of(context)
                                    .popUntil((predicate) => predicate.isFirst);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      ParticipantsView(),
                                ));
                              });
                            });
                          },
                          child: const Text("Alle scores en deelnemers vervangen door voorbeeld-data")),
                      //
                    ])),
          );
        });
  }

  Future<String> createSummary() async {
    var model = await MatchRepository().getModel();
    String result = 'Actieve wedstrijd: ${model.matchCode}: ${model.matchName}\n';
    result += 'Dit apparaat: ${model.deviceID}\n';
    result +=
        'Configuratie: ${model.numberOfEnds} rondes(s) van ${model.arrowsPerEnd} pijl(en)';
    result +=
        ' met ${model.groups.length} discipline(s), ${model.subgroups.length} klasse(s), en ${model.targets.length} blazoen(en)';
    result +=
        ' en ${model.scoreValues.entries.length} toesenbord(en)';

    return result;
  }
}
