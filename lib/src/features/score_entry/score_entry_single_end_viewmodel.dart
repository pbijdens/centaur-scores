import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/mvvm/viewmodel.dart';

import '../../model/match_model.dart';
import '../../model/participant_model.dart';

class ScoresSingleEndViewmodel extends EventViewModel {
  final MatchRepository _repository;
  MatchModel? _model;

  int _endNo;
  int _arrowNo;
  int _lijnNo;
  int _numberOfEnds = 1;

  ScoresSingleEndViewmodel(
      this._repository, this._lijnNo, this._endNo, this._arrowNo);

  void load() {
    notify(LoadingEvent(isLoading: true));
    _repository.getModel().then((value) {
      _model = value;
      _numberOfEnds = _model?.numberOfEnds ?? 1;

      notify(SingleEndViewmodelLoadedEvent(model: value));
      if (participant != null) {
        notify(ParticipantChangedEvent(
            participant: participant!, end: endNo, arrow: arrowNo));
      }
      notify(LoadingEvent(isLoading: false));
    });
  }

  int get numberOfEnds => _numberOfEnds;
  int get endNo => _endNo;
  int get arrowNo => _arrowNo;
  int get lijnNo => _lijnNo;

  ParticipantModel? get participant => _model?.participants[_lijnNo];

  void nextParticipant() {
    int nextLijn = _lijnNo;
    int participantArrayLength = _model?.participants.length ?? 0;
    for (int i = 0; i < participantArrayLength; i++) {
      // try at most as many times as there are array entries
      nextLijn = (nextLijn + 1) % participantArrayLength;
      ParticipantModel? newP = _model?.getParticipantByIndex(nextLijn);
      if (newP != null && (newP.name?.isNotEmpty ?? false)) {
        _lijnNo = nextLijn;
        _setArrowNo();
        notify(ParticipantChangedEvent(
            participant: newP, end: endNo, arrow: arrowNo));
        return;
      }
    }
  }

  void newline() {
    int nextLijn = -1;
    int participantArrayLength = _model?.participants.length ?? 0;
    for (int i = 0; i < participantArrayLength; i++) {
      // try at most as many times as there are array entries
      nextLijn = (nextLijn + 1) % participantArrayLength;
      ParticipantModel? newP = _model?.getParticipantByIndex(nextLijn);
      if (newP != null && (newP.name?.isNotEmpty ?? false)) {
        _lijnNo = nextLijn;
        _arrowNo = participant?.ends[endNo].arrows
                .indexWhere((element) => element == null) ??
            -1;
        if ((-1 == _arrowNo) && (_endNo < (_model?.numberOfEnds ?? 0) - 1)) {
          _endNo++;
        }
        _setArrowNo();
        notify(ParticipantChangedEvent(
            participant: newP, end: endNo, arrow: arrowNo));
        return;
      }
    }
  }

  void previousParticipant() {
    if (_model != null) {
      int nextLijn = _lijnNo;
      int participantArrayLength = _model?.participants.length ?? 0;
      for (int i = 0; i < participantArrayLength; i++) {
        // try at most as many times as there are array entries
        nextLijn =
            (participantArrayLength + nextLijn - 1) % participantArrayLength;
        ParticipantModel? newP = _model?.getParticipantByIndex(nextLijn);
        if (newP != null && (newP.name?.isNotEmpty ?? false)) {
          _lijnNo = nextLijn;
          _setArrowNo();
          notify(ParticipantChangedEvent(
              participant: newP, end: endNo, arrow: arrowNo));
          return;
        }
      }
    }
  }

  void hilightCell(int end, int arrow) {
    _arrowNo = arrow;
    notify(ArrowStateChangedEvent(
        participant: participant, end: end, arrow: arrow));
  }

  void hilightCellNoNotify(int end, int arrow) {
    _arrowNo = arrow;
  }

  void setScore(int? value) {
    if (null != participant) {
      _repository
          .setArrow(participant?.id ?? -1, _endNo, _arrowNo, value)
          .then((x) {
        if (_arrowNo < ((_model?.arrowsPerEnd ?? 0) - 1)) _arrowNo++;
        notify(ArrowStateChangedEvent(
            participant: participant, end: _endNo, arrow: _arrowNo));
      });
    }
  }

  void nextEnd() {
    _endNo++;
    _setArrowNo();
    notify(ArrowStateChangedEvent(
        participant: participant, end: _endNo, arrow: _arrowNo));
  }

  void previousEnd() {
    _endNo--;
    _setArrowNo();
    notify(ArrowStateChangedEvent(
        participant: participant, end: _endNo, arrow: _arrowNo));
  }

  void _setArrowNo() {
    if (_endNo < 0) {
      _endNo = 0;
    }
    if (_endNo >= (participant?.ends.length ?? 1)) {
      _endNo = (participant?.ends.length ?? 1) - 1;
    }
    _arrowNo = participant?.ends[endNo].arrows
            .indexWhere((element) => element == null) ??
        0;
  }

  ParticipantModel? previousParticipantData() {
    if (_model != null) {
      int nextLijn = _lijnNo;
      int participantArrayLength = _model?.participants.length ?? 0;
      for (int i = 0; i < participantArrayLength; i++) {
        // try at most as many times as there are array entries
        nextLijn =
            (participantArrayLength + nextLijn - 1) % participantArrayLength;
        ParticipantModel? newP = _model?.getParticipantByIndex(nextLijn);

        if (newP != null && (newP.name?.isNotEmpty ?? false)) {
          // Do not allow going back
          if (nextLijn >= _lijnNo) return null;
          return newP;
        }
      }
    }
    return null;
  }

  ParticipantModel? nextParticipantData() {
    int nextLijn = _lijnNo;
    int participantArrayLength = _model?.participants.length ?? 0;
    if (_model != null) {
      bool allComplete = true;
      for (int i = 0; i < participantArrayLength; i++) {
        ParticipantModel? newP = _model?.getParticipantByIndex(nextLijn);
        allComplete = allComplete &&
            ((newP?.name?.isEmpty ?? true) ||
                (newP?.ends[_endNo].score != null));
      }
      for (int i = 0; i < participantArrayLength; i++) {
        // try at most as many times as there are array entries
        nextLijn = (nextLijn + 1) % participantArrayLength;
        ParticipantModel? newP = _model?.getParticipantByIndex(nextLijn);

        if (newP != null && (newP.name?.isNotEmpty ?? false)) {
          // Do not allow going back when all data has been completed
          if (allComplete && nextLijn <= _lijnNo) return null;
          return newP;
        }
      }
    }
    return null;
  }

  int columnForParticipant(ParticipantModel participant) {
    var result =
        _model?.participants.indexWhere((x) => x.lijn == participant.lijn);
    return result ?? 0;
  }
}

class SingleEndViewmodelLoadedEvent extends ViewEvent {
  final MatchModel model;

  SingleEndViewmodelLoadedEvent({required this.model})
      : super("SingleEndViewmodelLoadedEvent");
}

class ParticipantChangedEvent extends ViewEvent {
  final ParticipantModel participant;
  final int end;
  final int arrow;

  ParticipantChangedEvent(
      {required this.participant, required this.end, required this.arrow})
      : super("ParticipantChangedEvent");
}

class ArrowStateChangedEvent extends ViewEvent {
  final ParticipantModel? participant;
  final int end;
  final int arrow;

  ArrowStateChangedEvent(
      {required this.participant, required this.end, required this.arrow})
      : super("ParticipantChangedEvent");
}
