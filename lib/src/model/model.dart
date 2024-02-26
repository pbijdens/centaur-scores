import 'dart:collection';

class ParticipantsModel {
  int id = 0;

  ParticipantsModel();

  final List<ParticipantModel> _participants = [
    ParticipantModel(id: 0, lijn: 'A'),
    ParticipantModel(id: 1, lijn: "B"),
    ParticipantModel(id: 2, lijn: "C"),
    ParticipantModel(id: 3, lijn: "D"),
  ];

  UnmodifiableListView<ParticipantModel> get participants =>
      UnmodifiableListView(_participants);

  updateParticipant(int id, ParticipantModel participant) {
    int participantIndex =
        participants.indexWhere((element) => element.id == id);
    if (participantIndex < 0) throw Exception("Participant not found");
    _participants[participantIndex] = participant;
  }
}

class ParticipantModel {
  int id = 0;

  final String lijn;

  ParticipantModel({required this.lijn, required this.id});

  String? name;
  void setName(String name) {
    this.name = name;
  }

  String group = "-";
  void setGroup(GroupInfo value) {
    group = value.code ?? "-";
  }

  String subgroup = "-";
  void setSubgroup(GroupInfo value) {
    subgroup = value.code ?? "-";
  }

  List<EndModel> _ends = [];
  UnmodifiableListView<EndModel> get ends => UnmodifiableListView(_ends);

  void updateArrow(int end, int arrow, int value) {
    _ends[end].set(arrow, value);
  }

  void initialize(int ends, int arrowsPerEnd) {
    _ends = [];
    for (var i = 0; i < ends; i++) {
      EndModel endModel = EndModel();
      endModel.initialize(arrowsPerEnd);
      _ends.add(endModel);
    }
  }

  int get score => calculateScore();

  int calculateScore() {
    int score = 0;
    for (EndModel end in _ends) {
      score += end.score ?? 0;
    }
    return score;
  }
}

class EndModel {
  List<int?> _arrows = [];
  UnmodifiableListView<int?> get arrows => UnmodifiableListView(_arrows);

  void initialize(int arrowsPerEnd) {
    _arrows = List<int?>.filled(arrowsPerEnd, null);
  }

  void set(int index, int value) {
    if (index >= _arrows.length) return;
    _arrows[index] = value;
  }

  int? get score => calculateScore();

  int? calculateScore() {
    int sum = 0;
    for (var element in _arrows) {
      sum += element ?? 0;
      if (element == null) return null; // end score is void when not all arrows
      // are filled in
    }
    return sum;
  }
}

class GroupInfo {
  String? label;
  String? code;
  GroupInfo(this.label, this.code);
}

class MatchModel {
  String deviceID = "ABCDEF";
  String wedstrijdCode = "ICW8";
  String wedstrijdNaam = "Competitie week 8";
  int ends = 10;
  int arrowsPerEnd = 3;
  Map<String, List<int>> scoreValues = {
    "-": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "R": [6, 7, 8, 9, 10],
    "C": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "H": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  };

  List<GroupInfo> groups = [
    GroupInfo("Onbekend", "-"),
    GroupInfo("Recurve", "R"),
    GroupInfo("Compound", "C"),
    GroupInfo("Hout/Barebow", "H")
  ];

  List<GroupInfo> subgroups = [
    GroupInfo("Onbekend", "-"),
    GroupInfo("Senioren", "S"),
    GroupInfo("Junioren", "J")
  ];

  ParticipantsModel participants = ParticipantsModel();

  Future load() async {
    // groups;
    participants = ParticipantsModel();

    for (ParticipantModel participant in participants.participants) {
      participant.initialize(ends, arrowsPerEnd);
    }

    await Future.delayed(const Duration(seconds: 1));
    return Future.value();
  }
}
