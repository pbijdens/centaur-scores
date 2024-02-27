import 'package:centaur_scores/src/model/model.dart';
import 'package:flutter/material.dart';

class ScoreFormHelper {
  static const double preferredCellWidth = 40;
  static const double preferredCellHeight = 20;
  static const double childAspectRatio = ScoreFormHelper.preferredCellWidth /
      ScoreFormHelper.preferredCellHeight;

  static Color colorForColumn(int columnNo) {
    List<Color> colors = [
      Colors.blue.shade500,
      Colors.red.shade400,
      Colors.yellow.shade500,
      Colors.orange.shade500,
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
      return const Color.fromRGBO(0xEE, 0xEE, 0xEE, 1.0);
    }
    if (arrowValue >= 9) return Colors.yellow.withOpacity(0.25);
    if (arrowValue >= 7) return Colors.red.withOpacity(0.25);
    if (arrowValue >= 5) return Colors.blue.withOpacity(0.25);
    if (arrowValue >= 3) return Colors.black.withOpacity(0.25);
    return const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1.0);
  }
}
