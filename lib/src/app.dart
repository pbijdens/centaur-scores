import 'package:centaur_scores/src/features/score_transfer/score_transfer.dart';
import 'package:centaur_scores/src/mycustomscrollbehavior.dart';
import 'package:centaur_scores/src/navigationservice.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/features/participants/participants_view.dart';
import 'package:centaur_scores/src/features/score_entry/score_entry_single_end.dart';
import 'package:centaur_scores/src/features/score_card/scores_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var innerBuilder = ListenableBuilder(
      listenable: MatchRepository(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Root key
          navigatorKey: NavigationService.navigatorKey,

          scrollBehavior: MyCustomScrollBehavior(),

          debugShowCheckedModeBanner: false,

          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case ScoresView.routeName:
                    return const ScoresView();
                  case ScoreEntryForSingleEndView.routeName:
                    return const ScoreEntryForSingleEndView(
                        lijnNo: 0, endNo: -1, arrowNo: -1);
                  case SettingsView.routeName:
                    return SettingsView();
                  case ScoreTransferView.routeName:
                  case ParticipantsView.routeName:
                  default:
                    return const ParticipantsView();
                }
              },
            );
          },
        );
      },
    );

    var builder = FutureBuilder<Null>(
      future: initialize(),
      builder: (context, snapshot) => innerBuilder,
    );

    return builder;

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
  }

  Future<Null> initialize() async {
    debugPrint("Initializing MyApp");
    final matchRepository = MatchRepository();
    matchRepository.onModelReplaced = (completer) async {
      debugPrint("onModelReplaced");
      MyApp.onRepositoryChanged();
    };

    debugPrint("matchRepository.initialize()..");
    // Load the current state for the application (fire and forget)
    await matchRepository.initialize();
  }

  static Widget drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text('Centaur Scores',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Schutters'),
            onTap: () {
              Navigator.of(context).popUntil((predicate) => predicate.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) => const ParticipantsView(),
              ));
            },
          ),
          ListTile(
            title: const Text('Scores'),
            onTap: () {
              Navigator.of(context).popUntil((predicate) => predicate.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) => const ScoresView(),
              ));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Instellingen'),
            onTap: () {
              Navigator.of(context).popUntil((predicate) => predicate.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) => SettingsView(),
              ));
            },
          ),
        ],
      ),
    );
  }

  static void onRepositoryChanged() {
    var context = NavigationService.navigatorKey.currentContext;
    debugPrint("onRepositoryChanged - invoked");
    if (context != null) {
      debugPrint("onRepositoryChanged - working");
      var navigator = Navigator.of(context, rootNavigator: true);
      navigator.popUntil((predicate) => predicate.isFirst);
      navigator.pushReplacement(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const ParticipantsView();
        },
      ));
    }
  }
}
