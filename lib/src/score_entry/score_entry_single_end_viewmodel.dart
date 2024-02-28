import 'package:centaur_scores/src/model/model.dart';
import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/mvvm/viewmodel.dart';
import 'package:centaur_scores/src/participants/participants_viewmodel.dart';

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
      _numberOfEnds = _model?.ends ?? 1;

      notify(SingleEndViewmodelLoadedEvent(model: value));
      if (participant != null) {
        notify(ParticipantChangedEvent(participant: participant!));
      }
      notify(LoadingEvent(isLoading: false));
    });
  }

  int get numberOfEnds => _numberOfEnds;
  int get endNo => _endNo;
  int get arrowNo => _arrowNo;
  int get lijnNo => _lijnNo;

  ParticipantModel? get participant =>
      _repository.getParticipantByIndex(_model, _lijnNo);

  void nextParticipant() {
    int nextLijn = _lijnNo;
    int participantArrayLength = _model?.participants.participants.length ?? 0;
    for (int i = 0; i < participantArrayLength; i++) {
      // try at most as many times as there are array entries
      nextLijn = (nextLijn + 1) % participantArrayLength;
      ParticipantModel? newP =
          _repository.getParticipantByIndex(_model, nextLijn);
      if (newP != null && (newP.name?.isNotEmpty ?? false)) {
        _lijnNo = nextLijn;
        notify(ParticipantChangedEvent(participant: newP));
      }
    }
  }

  void previousParticipant() {
    if (_model != null) {
      int nextLijn = _lijnNo;
      int participantArrayLength =
          _model?.participants.participants.length ?? 0;
      for (int i = 0; i < participantArrayLength; i++) {
        // try at most as many times as there are array entries
        nextLijn =
            (participantArrayLength + nextLijn - 1) % participantArrayLength;
        ParticipantModel? newP =
            _repository.getParticipantByIndex(_model, nextLijn);
        if (newP != null && (newP.name?.isNotEmpty ?? false)) {
          _lijnNo = nextLijn;
          notify(ParticipantChangedEvent(participant: newP));
        }
      }
    }
  }

  void hilightCell(int end, int arrow) {
    _arrowNo = arrow;
    notify(ArrowStateChangedEvent(
        participant: _model?.participants.participants[_lijnNo],
        end: end,
        arrow: arrow));
  }

  void setScore(int? value) {
    var participant = _model?.participants.participants[_lijnNo];
    if (null != participant) {
      participant.setArrow(_endNo, _arrowNo, value);
      if (_arrowNo < ((_model?.arrowsPerEnd ?? 0) - 1)) _arrowNo++;
      notify(ArrowStateChangedEvent(
          participant: _model?.participants.participants[_lijnNo],
          end: _endNo,
          arrow: _arrowNo));
    }
  }

  void nextEnd() {
    _endNo++;
    _setArrowNo();
    notify(ArrowStateChangedEvent(
        participant: _model?.participants.participants[_lijnNo],
        end: _endNo,
        arrow: _arrowNo));
  }

  void previousEnd() {
    _endNo--;
    _setArrowNo();
    notify(ArrowStateChangedEvent(
        participant: _model?.participants.participants[_lijnNo],
        end: _endNo,
        arrow: _arrowNo));
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
}

class SingleEndViewmodelLoadedEvent extends ViewEvent {
  final MatchModel model;

  SingleEndViewmodelLoadedEvent({required this.model})
      : super("SingleEndViewmodelLoadedEvent");
}

class ParticipantChangedEvent extends ViewEvent {
  final ParticipantModel participant;

  ParticipantChangedEvent({required this.participant})
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
