import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:flutter/material.dart';

// Place this widget in the title bar on any page to show the current
// synchronization status.
class ScoreSyncWidget extends StatefulWidget {
  const ScoreSyncWidget({super.key});

  @override
  ScoreSyncWidgetState createState() {
    return ScoreSyncWidgetState();
  }
}

class ScoreSyncWidgetState extends State<ScoreSyncWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 20.0;

    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Padding(
              padding: const EdgeInsets.only(right: size * 0.25),
              child: FutureBuilder<MatchModel>(
                  future: MatchRepository().getModel(),
                  builder: (context, snapshot) {
                    bool isDirty = snapshot.data?.isDirty ?? true;
                    return SizedBox(
                      width: size,
                      height: size,
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: isDirty
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              border: Border.all(
                                color: isDirty
                                    ? Colors.red.shade800
                                    : Colors.green.shade800,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(size))),
                          child: isDirty
                              ? Icon(
                                  Icons.sync_disabled_sharp,
                                  color: Colors.red.shade800,
                                  size: size * 0.9,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                )
                              : Icon(
                                  Icons.sync_sharp,
                                  color: Colors.green.shade800,
                                  size: size * 0.9,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                )),
                    );
                  }));
        });
  }
}
