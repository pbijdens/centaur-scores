import 'dart:async';

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
        debugPrint("Error From INSIDE FRAMEWORK");
        debugPrint("----------------------");
        debugPrint("Error :  ${details.exception}");
        debugPrint("StackTrace :  ${details.stack}");
      };

      runApp(const MyApp());
    },
    (dynamic error, StackTrace stackTrace) {
      debugPrint("=================== CAUGHT DART ERROR $error $stackTrace");
      // Send report
    },
  );
}
