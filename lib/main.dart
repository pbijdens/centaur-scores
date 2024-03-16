import 'dart:async';

import 'package:centaur_scores/src/repository/repository.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runZonedGuarded<Future<void>>(
    () async {
      // Set up the SettingsController, which will glue user settings to multiple
      // Flutter Widgets.
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (FlutterErrorDetails details) {
        //this line prints the default flutter gesture caught exception in console
        //FlutterError.dumpErrorToConsole(details);
        print("Error From INSIDE FRAME_WORK");
        print("----------------------");
        print("Error :  ${details.exception}");
        print("StackTrace :  ${details.stack}");
      };

      runApp(MyApp());
    },
    (dynamic error, StackTrace stackTrace) {
      print("=================== CAUGHT DART ERROR $error $stackTrace");
      // Send report
    },
  );
}
