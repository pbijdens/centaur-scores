import 'package:centaur_scores/src/model/repository.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final matchRepository = MatchRepository();

  // Load the current state for the application (fire and forget)
  matchRepository.load();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp());
}
