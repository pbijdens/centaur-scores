import 'package:centaur_scores/src/model/model.dart';
import 'package:flutter/material.dart';

class ScoreFormHelper {
  static const double preferredCellWidth = 80 * 1.20;
  static const double preferredCellHeight = 45 * 1.20;

  static double childAspectRatio(MatchModel model) =>
      ScoreFormHelper.preferredCellWidth / ScoreFormHelper.preferredCellHeight;

  static double childAspectRatioForEditor(MatchModel model) =>
      ScoreFormHelper.preferredCellWidth / ScoreFormHelper.preferredCellHeight;

  static double scoreCardColumnWidth(MatchModel model) =>
      (model.arrowsPerEnd + 2) * ScoreFormHelper.preferredCellWidth;

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
}
