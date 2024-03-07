import 'dart:async';

import 'package:centaur_scores/src/model/match_model.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:flutter/material.dart';

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
    return ListenableBuilder(
        listenable: MatchRepository(),
        builder: (BuildContext context, Widget? child) {
          return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FutureBuilder<MatchModel>(
                  future: MatchRepository().getModel(),
                  builder: (context, snapshot) {
                    bool isDirty = snapshot.data?.isDirty ?? true;
                    return Container(
                        color: isDirty
                            ? Colors.red.shade200
                            : Colors.green.shade200,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(isDirty ? '-' : '+')),
                        ));
                  }));
        });
  }
}
