class EndModel {
  late List<int?> arrows;

  int? get score => calculateScore();

  int? calculateScore() {
    int sum = 0;
    for (var element in arrows) {
      sum += element ?? 0;
      if (element == null) return null; // end score is void when not all arrows
      // are filled in
    }
    return sum;
  }
}
