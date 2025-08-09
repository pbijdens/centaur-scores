import 'package:centaur_scores/src/model/score_button_definition.dart';
import 'package:flutter/material.dart';

import '../model/match_model.dart';

class StyleHelper {
  static const double endNumberWidth = 25;
  static const double endTotalWidth = 30;
  static const double subTotalWidth = 45;
  static const double scFixedWidth =
      endNumberWidth + endTotalWidth + subTotalWidth;
  static const double scLine1Height = 40;
  static const double scLine2Height = 30;
  static const double scFooterHeight = 55;
  static const double scVerticalOverhead = 175 + scFooterHeight;

  static double scale(BuildContext context) => 1.1;

  static double min(double a, double b) => a < b ? a : b;
  static double max(double a, double b) => a > b ? a : b;

  static double preferredCellWidth(BuildContext context, MatchModel model) {
    MediaQueryData q = MediaQuery.of(context);
    double screenWidth = q.size.width;
    double singleColumnPreferredWidth = screenWidth / 4.0;
    if (q.orientation == Orientation.portrait) {
      singleColumnPreferredWidth = q.size.width * 0.85;
      //(((q.size.width * 0.85) - scFixedWidth)) / (model.arrowsPerEnd);
    } else {}
    double minColumnWidth = (model.arrowsPerEnd * 40) + scFixedWidth;
    double maxColumnWidth = (model.arrowsPerEnd * 70) + scFixedWidth;
    double finalColumnWidth =
        min(max(singleColumnPreferredWidth, minColumnWidth), maxColumnWidth);
    return (finalColumnWidth - scFixedWidth) / model.arrowsPerEnd;
  }

  static double preferredCellHeight(BuildContext context, MatchModel model) {
    MediaQueryData q = MediaQuery.of(context);
    int endsToShow = model.numberOfEnds > 10 ? 12 : model.numberOfEnds;
    double result = (q.size.height - scVerticalOverhead) / endsToShow;
    if (result < 30) {
      result = 30;
    } else if (result > 55) {
      result = 55;
    }
    return result;
  }

  static double childAspectRatio(BuildContext context, MatchModel model) => 2;

  static double childAspectRatioForEditor(
          BuildContext context, MatchModel model) =>
      2;

  static double scoreCardColumnWidth(BuildContext context, MatchModel model) {
    return (preferredCellWidth(context, model) * model.arrowsPerEnd) +
        scFixedWidth;
  }

  static double scoreCardRowHeight(BuildContext context, MatchModel model) {
    return preferredCellHeight(context, model);
  }

  static Color colorForColumn(int columnNo) {
    List<Color> colors = [
      darken(colorForScoreForm(0), 0.1),
      darken(colorForScoreForm(1), 0.1),
      darken(colorForScoreForm(2), 0.1),
      darken(colorForScoreForm(3), 0.1),
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForCellBorder(int columnNo) {
    List<Color> colors = [
      darken(colorForScoreForm(0), 0.4),
      darken(colorForScoreForm(1), 0.4),
      darken(colorForScoreForm(2), 0.4),
      darken(colorForScoreForm(3), 0.4),
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForScoreForm(int columnNo) {
    List<Color> colors = [
      lighten(Colors.blue.shade100, 0.05),
      lighten(Colors.red.shade100, 0.05),
      lighten(Colors.yellow.shade100, 0.05),
      lighten(Colors.orange.shade100, 0.05),
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForColumnFooter(int columnNo) {
    List<Color> colors = [
      darken(colorForScoreForm(0), 0.2),
      darken(colorForScoreForm(1), 0.2),
      darken(colorForScoreForm(2), 0.2),
      darken(colorForScoreForm(3), 0.2),
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForArrow(int? arrowValue) {
    if (null == arrowValue) {
      return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.5);
    }
    if (arrowValue >= 12) return Colors.lime;
    if (arrowValue >= 9) return Colors.yellow;
    if (arrowValue >= 7) return Colors.red;
    if (arrowValue >= 5) return Colors.blue;
    if (arrowValue >= 3) return Colors.black;
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
  }

  static Color colorForButtonSelected(BuildContext context) {
    return Colors.white;
  }

  static Color colorForButton(BuildContext context, int? arrowValue) {
    if (null == arrowValue) {
      return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1);
    }
    if (arrowValue >= 9) return Colors.yellow;
    if (arrowValue >= 7) return Colors.red;
    if (arrowValue >= 5) return Colors.blue;
    if (arrowValue >= 3) return Colors.black;
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
  }

  static Color colorForButtonLabel(BuildContext context, int? arrowValue) {
    return colorForButton(context, arrowValue).computeLuminance() < 0.5
        ? darken(Colors.white, 0.05)
        : Colors.black87;
  }

  static colorForEditRow() {
    return Colors.white;
  }

  static const int numKeysPerRow = 4;

  static TextStyle? baseTextStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyLarge
      ?.apply(fontSizeFactor: scale(context) * 1);

  static TextStyle? participantLijnTextStyle(BuildContext context) =>
      baseTextStyle(context);

  static TextStyle? participantGroupDropdownTextStyle(BuildContext context) =>
      baseTextStyle(context);

  static TextStyle? participantSubgroupDropdownTextStyle(
          BuildContext context) =>
      baseTextStyle(context);

  static TextStyle? participantTargetDropdownTextStyle(BuildContext context) =>
      baseTextStyle(context);

  static TextStyle? nextPrevEndEndNoTextStyle(BuildContext context) =>
      baseTextStyle(context)
          ?.apply(fontSizeFactor: scale(context) * 0.9, color: Colors.black54);

  static TextStyle? nextPrevEndArrowScoreTextStyle(BuildContext context) =>
      baseTextStyle(context)
          ?.apply(fontSizeFactor: scale(context) * 0.9, color: Colors.black54);

  static TextStyle? nextPrevEndEndScoreTextStyle(BuildContext context) =>
      baseTextStyle(context)
          ?.apply(fontSizeFactor: scale(context) * 0.9, color: Colors.black54);

  static TextStyle? endEditorEndNoTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: scale(context) * 0.9,
          fontWeightDelta: 0,
          color: Colors.black54);

  static TextStyle? endEditorArrowScoreTextStyle(BuildContext context) =>
      baseTextStyle(context)
          ?.apply(fontSizeFactor: scale(context) * 1.1, fontWeightDelta: 0);

  static TextStyle? endEditorEndTotalTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: scale(context) * 0.9,
          fontWeightDelta: 0,
          color: Colors.black54);

  static TextStyle? endEditorBackButtonTextStyle(BuildContext context) =>
      baseTextStyle(context);

  static TextStyle? endEditorTopHeaderTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: scale(context) * 1);

  static TextStyle? endEditorTopHeaderBoldTextStyle(BuildContext context) =>
      endEditorTopHeaderTextStyle(context)?.apply(fontWeightDelta: 4);

  static TextStyle? editorParticipantNameHeader(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: scale(context) * 1.1);

  static TextStyle? keypadTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: scale(context) * 1.1);

  static TextStyle? keypadTextStyleSmall(BuildContext context, String label) =>
      label.length >= 3
          ? baseTextStyle(context)?.apply(fontSizeFactor: scale(context) * 0.8)
          : baseTextStyle(context)?.apply(fontSizeFactor: scale(context) * 1.1);

  static TextStyle? scoreFormFooterTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: scale(context) * 1.1);

  static TextStyle? scoreFormHeaderParticipantNameTextStyle(
          BuildContext context) =>
      editorParticipantNameHeader(context);

  static TextStyle? scoreFormHeaderLineTwoTextStyle(BuildContext context) =>
      endEditorTopHeaderTextStyle(context);

  static TextStyle? scoreFormHeaderLineTwoBoldTextStyle(BuildContext context) =>
      endEditorTopHeaderBoldTextStyle(context);

  static TextStyle? scoreFormEndNumberTextStyle(BuildContext context) =>
      endEditorEndNoTextStyle(context);

  static TextStyle? scoreFormArrowScoreTextStyle(
          BuildContext context, int? score) =>
      colorForArrow(score).computeLuminance() < 0.5
          ? endEditorArrowScoreTextStyle(context)
              ?.apply(color: darken(Colors.white, 0.05))
          : endEditorArrowScoreTextStyle(context)?.apply(color: Colors.black87);

  static TextStyle? scoreFormArrowScoreTextStyleSelected(
          BuildContext context) =>
      colorForButtonSelected(context).computeLuminance() < 0.5
          ? endEditorArrowScoreTextStyle(context)
              ?.apply(color: darken(Colors.white, 0.05))
          : endEditorArrowScoreTextStyle(context)?.apply(color: Colors.black87);

  static TextStyle? scoreFormEndTotalTextStyle(BuildContext context) =>
      endEditorEndTotalTextStyle(context);

  static TextStyle? noMoreEndsTextStyle(BuildContext context) =>
      baseTextStyle(context)
          ?.apply(fontSizeFactor: scale(context) * 0.9, color: Colors.black54);

  static TextStyle? participantEntryHeading1TextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: scale(context) * 1.1,
          fontWeightDelta: 2,
          color: Colors.black87);

  static TextStyle? participantEntryLabelTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: scale(context) * 0.9,
          fontWeightDelta: 2,
          color: Colors.black87);

  static TextStyle? participantNameTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: scale(context) * 1,
          fontWeightDelta: 1,
          color: Colors.black87);

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static double keyboardButtonRowHeight(BuildContext context, MatchModel match,
      int buttonsPerRow, List<ScoreButtonDefinition> keys) {
    MediaQueryData q = MediaQuery.of(context);
    double result;
    if (q.size.height > 600) {
      result = 60 * scale(context);
    } else {
      result = 40 * scale(context);
      // double space = q.size.height - scVerticalOverhead;
      // double kbSpace = preferredCellHeight(context, match);
      // space -= 3 * kbSpace;
      // result = space / ((1.0 * keys.length) / (1.0 * buttonsPerRow));
    }
    debugPrint("Returning $result");
    return result;
    // return 45 * scale(context);
  }
}
