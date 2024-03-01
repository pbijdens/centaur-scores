import 'package:flutter/material.dart';

import '../model/match_model.dart';

class StyleHelper {
  static const double preferredCellWidth = 80 * 1.20;
  static const double preferredCellHeight = 45 * 1.20;

  static double childAspectRatio(MatchModel model) =>
      StyleHelper.preferredCellWidth / StyleHelper.preferredCellHeight;

  static double childAspectRatioForEditor(MatchModel model) =>
      StyleHelper.preferredCellWidth / StyleHelper.preferredCellHeight;

  static double scoreCardColumnWidth(MatchModel model) =>
      (model.arrowsPerEnd + 2) * StyleHelper.preferredCellWidth;

  static Color colorForColumn(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade500,
      Colors.red.shade400,
      Colors.yellow.shade500,
      Colors.orange.shade500,
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForCellBorder(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade800,
      Colors.red.shade800,
      Colors.yellow.shade800,
      Colors.orange.shade800,
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForScoreForm(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade50,
      Colors.red.shade50,
      Colors.yellow.shade50,
      Colors.orange.shade50,
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForColumnFooter(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade100,
      Colors.red.shade100,
      Colors.yellow.shade100,
      Colors.orange.shade100,
    ];
    return colors[columnNo % colors.length];
  }

  static Color colorForArrow(MatchModel model, int? arrowValue) {
    if (null == arrowValue) {
      return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.5);
    }
    if (arrowValue >= 12) return Colors.lime.withOpacity(0.25);
    if (arrowValue >= 9) return Colors.yellow.withOpacity(0.25);
    if (arrowValue >= 7) return Colors.red.withOpacity(0.25);
    if (arrowValue >= 5) return Colors.blue.withOpacity(0.25);
    if (arrowValue >= 3) return Colors.black.withOpacity(0.25);
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0).withOpacity(0.5);
  }

  static Color colorForButton(MatchModel model, int? arrowValue) {
    if (null == arrowValue) {
      return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1);
    }
    if (arrowValue >= 9) return Colors.yellow;
    if (arrowValue >= 7) return Colors.red;
    if (arrowValue >= 5) return Colors.blue;
    if (arrowValue >= 3) return Colors.black;
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
  }

  static Color colorForButtonLabel(MatchModel model, int? arrowValue) {
    if (null == arrowValue) {
      return Colors.black54;
    }
    if (arrowValue >= 9) return Colors.black;
    if (arrowValue >= 7) return Colors.white;
    if (arrowValue >= 5) return Colors.black;
    if (arrowValue >= 3) return Colors.white;
    if (arrowValue >= 1) return Colors.black;
    return Colors.black54;
  }

  static colorForEditRow() {
    return Colors.white;
  }

  static const int numKeysPerRow = 4;

  static TextStyle? baseTextStyle(BuildContext context) => Theme.of(context).textTheme.bodyLarge?.apply(fontSizeFactor: 1.15);

  static TextStyle? participantLijnTextStyle(BuildContext context) => baseTextStyle(context);

  static TextStyle? participantGroupDropdownTextStyle(BuildContext context) => baseTextStyle(context);

  static TextStyle? participantSubgroupDropdownTextStyle(BuildContext context) => baseTextStyle(context);

  static TextStyle? nextPrevEndEndNoTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? nextPrevEndArrowScoreTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? nextPrevEndEndScoreTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? endEditorEndNoTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.2, fontWeightDelta: 0, color: Colors.black54);

  static TextStyle? endEditorArrowScoreTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.5, fontWeightDelta: 0);

  static TextStyle? endEditorEndTotalTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.2, fontWeightDelta: 0, color: Colors.black54);

  static TextStyle? endEditorBackButtonTextStyle(BuildContext context) => baseTextStyle(context);

  static TextStyle? endEditorTopHeaderTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1);

  static TextStyle? endEditorTopHeaderBoldTextStyle(BuildContext context) => endEditorTopHeaderTextStyle(context)?.apply(fontWeightDelta: 4);

  static TextStyle? editorParticipantNameHeader(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.7);

  static TextStyle? keypadTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.5);

  static TextStyle? scoreFormFooterTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.2);

  static TextStyle? scoreFormHeaderParticipantNameTextStyle(BuildContext context) => editorParticipantNameHeader(context);

  static TextStyle? scoreFormHeaderLineTwoTextStyle(BuildContext context) => endEditorTopHeaderTextStyle(context);

  static TextStyle? scoreFormHeaderLineTwoBoldTextStyle(BuildContext context) => endEditorTopHeaderBoldTextStyle(context);

  static TextStyle? scoreFormEndNumberTextStyle(BuildContext context) => endEditorEndNoTextStyle(context);

  static TextStyle? scoreFormArrowScoreTextStyle(BuildContext context) => endEditorArrowScoreTextStyle(context);

  static TextStyle? scoreFormEndTotalTextStyle(BuildContext context) => endEditorEndTotalTextStyle(context);

  static TextStyle? noMoreEndsTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 0.9, color: Colors.black54);

  static TextStyle? participantEntryHeading1TextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.1, fontWeightDelta: 2, color: Colors.black87);

  static TextStyle? participantEntryLabelTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 0.9, fontWeightDelta: 2, color: Colors.black87);

  static TextStyle? participantNameTextStyle(BuildContext context) => baseTextStyle(context)?.apply(fontSizeFactor: 1.2, fontWeightDelta: 1, color: Colors.black87);
}
