import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/features/participants/participants_view.dart';
import 'package:centaur_scores/src/features/syncwidget/score_sync_widget.dart';
import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/model/participant_model.dart';
import 'package:centaur_scores/src/repository/centaur_scores_api.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/style/style_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreTransferView extends StatelessWidget {
  final ParticipantModel participant;
  const ScoreTransferView({required this.participant, super.key});

  static const routeName = '/xfer';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              appBar: AppBar(
                title: Row(children: [
                  const ScoreSyncWidget(),
                  Text(AppLocalizations.of(context)!.transferScreenTitle)
                ]),
              ),
              drawer: MyApp.drawer(context),
              body: Container(
                  margin: const EdgeInsets.all(20),
                  child: ScoreTransferPage(participant: participant))
              //
              );
        });
  }
}

class ScoreTransferPage extends StatelessWidget {
  final ParticipantModel participant;
  const ScoreTransferPage({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ParticipantModel>>(
        future: loadData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ParticipantModel>> participants) {
          return ListView.builder(
              itemCount: participants.data?.length ?? 0,
              itemBuilder: (context, index) {
                final ParticipantModel? remoteParticipant = participants.data?[index];
                return ScoreTransferListItem(participant: participant, remoteParticipant: remoteParticipant!);
              });
        });
  }

  Future<List<ParticipantModel>> loadData() async {
    MatchModel activeMatch = await MatchRepository().getModel();
    List<ParticipantModel> result =
        await CentaurScoresAPI().httpGetAllParticipantsForMatch(activeMatch.id);
    return result;
  }
}

class ScoreTransferListItem extends StatelessWidget {
  final ParticipantModel participant;
  final ParticipantModel remoteParticipant;
  const ScoreTransferListItem({
    super.key,
    required this.participant,
    required this.remoteParticipant
  });

  @override
  Widget build(BuildContext context) {
    final repository = MatchRepository();
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('${remoteParticipant.name} (${remoteParticipant.score})'),
              subtitle: Text('Lijn: ${remoteParticipant.lijn} @ ${remoteParticipant.deviceID}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('OVERNEMEN'),
                  onPressed: () {
                    repository.TransferTo(participant, remoteParticipant);
                    Navigator.of(context).popUntil((predicate) => predicate.isFirst);
                    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                      builder: (BuildContext context) => const ParticipantsView(),
                    ));                    
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
