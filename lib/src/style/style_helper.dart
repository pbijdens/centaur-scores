import 'package:flutter/material.dart';

import '../model/match_model.dart';

class StyleHelper {
  static const double preferredCellWidth = 80 * 1.20;
  static const double preferredCellHeight = 50 * 1.20;

  static double childAspectRatio(MatchModel model) =>
      StyleHelper.preferredCellWidth / StyleHelper.preferredCellHeight;

  static double childAspectRatioForEditor(MatchModel model) =>
      StyleHelper.preferredCellWidth / StyleHelper.preferredCellHeight;

  static double scoreCardColumnWidth(MatchModel model) =>
      (model.arrowsPerEnd + 2) * StyleHelper.preferredCellWidth;

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

  static TextStyle? baseTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge?.apply(fontSizeFactor: 1.15);

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
      baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? nextPrevEndArrowScoreTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? nextPrevEndEndScoreTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? endEditorEndNoTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: 1.2, fontWeightDelta: 0, color: Colors.black54);

  static TextStyle? endEditorArrowScoreTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 1.5, fontWeightDelta: 0);

  static TextStyle? endEditorEndTotalTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: 1.2, fontWeightDelta: 0, color: Colors.black54);

  static TextStyle? endEditorBackButtonTextStyle(BuildContext context) =>
      baseTextStyle(context);

  static TextStyle? endEditorTopHeaderTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 1);

  static TextStyle? endEditorTopHeaderBoldTextStyle(BuildContext context) =>
      endEditorTopHeaderTextStyle(context)?.apply(fontWeightDelta: 4);

  static TextStyle? editorParticipantNameHeader(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 1.7);

  static TextStyle? keypadTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 1.5);

  static TextStyle? scoreFormFooterTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 1.2);

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

  static TextStyle? scoreFormEndTotalTextStyle(BuildContext context) =>
      endEditorEndTotalTextStyle(context);

  static TextStyle? noMoreEndsTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? participantEntryHeading1TextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: 1.1, fontWeightDelta: 2, color: Colors.black87);

  static TextStyle? participantEntryLabelTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: 0.9, fontWeightDelta: 2, color: Colors.black87);

  static TextStyle? participantNameTextStyle(BuildContext context) =>
      baseTextStyle(context)?.apply(
          fontSizeFactor: 1.2, fontWeightDelta: 1, color: Colors.black87);

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
}
