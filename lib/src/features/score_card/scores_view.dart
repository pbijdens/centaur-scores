import 'package:centaur_scores/src/app.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/features/score_card/score_entry_fullpage_widget.dart';
import 'package:centaur_scores/src/features/syncwidget/score_sync_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoresView extends StatelessWidget {
  const ScoresView({super.key});

  static const routeName = '/scores';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(40.0),
                  child: AppBar(
                      title: Row(
                    children: [
                      const ScoreSyncWidget(),
                      Text(AppLocalizations.of(context)!.scoresScreenTitle)
                    ],
                  ))),
              drawer: MyApp.drawer(context),
              body: Container(
                  margin: const EdgeInsets.all(0),
                  child: const ScoreEntryFullPageWidget()));
        });
  }
}
