import 'package:centaur_scores/src/features/score_entry/score_entry_single_end_viewmodel.dart';
import 'package:centaur_scores/src/model/participant_model.dart';
import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/mvvm/viewmodel.dart';

import '../../model/match_model.dart';

class ScoresViewmodel extends EventViewModel {
  final MatchRepository _repository;

  int? activeKeyboard;
  int editingEnd = -1;
  int? editingArrow = -1;

  ScoresViewmodel(this._repository);

  void notifyViewmodelUpdated() {
    notify(ScoresViewmodelUpdatedEvent());
  }

  void load() {
    notify(LoadingEvent(isLoading: true));
    _repository.getModel().then((value) {
      notify(ScoresViewmodelLoadedEvent(model: value));
      notify(LoadingEvent(isLoading: false));
    });
  }

  void hideKeyboard() {
    activeKeyboard = null;
    notifyViewmodelUpdated();
    notifyKeyboardShown();
  }

  void nextKeyboard(MatchModel model, int endNo, int? arrowNumber) {
    if (activeKeyboard == null) return;
    activeKeyboard = activeKeyboard! + 1;
    if (activeKeyboard! >= model.participants.length) {
      if (editingEnd < model.numberOfEnds) {
        editingEnd = editingEnd + 1;
      }
      activeKeyboard = 0;
    }

    editingArrow = 0;
    for (int i = 0; i < model.arrowsPerEnd; i++) {
      if (model.participants[activeKeyboard!].ends[editingEnd].arrows[i] ==
          null) {
        editingArrow = i;
        break;
      }
    }

    notifyViewmodelUpdated();
    notifyKeyboardShown();
    notifActiveArrowChanged();
  }

  void activateKeyboard(
      MatchModel model, int? index, int endNo, int? arrowNumber) {
    bool activeKeyboardChanged = false;
    bool activeArrowChanged = false;

    if (editingEnd != endNo || editingArrow != arrowNumber) {
      activeArrowChanged = true;
      editingEnd = endNo;
      editingArrow = arrowNumber;
    }
    if (activeKeyboard != index) {
      activeKeyboardChanged = true;
      activeKeyboard = index;
    }

    if (editingEnd >= 0 &&
        (editingArrow == null ||
            editingArrow! < 0 ||
            editingArrow! >= model.arrowsPerEnd)) {
      editingArrow = 0;
      for (int i = 0; i < model.arrowsPerEnd; i++) {
        if (model.participants[index!].ends[editingEnd].arrows[i] == null) {
          editingArrow = i;
          activeArrowChanged = true;
          break;
        }
      }
    }

    if (activeArrowChanged || activeKeyboardChanged) {
      notifyViewmodelUpdated();
      if (activeKeyboardChanged) notifyKeyboardShown();
      if (activeArrowChanged) notifActiveArrowChanged();
    }
  }

  void setScore(int? value, MatchModel model, ParticipantModel participant) {
    if (null != editingArrow && null != activeKeyboard) {
      _repository
          .setArrow(participant.id, editingEnd, editingArrow!, value)
          .then((x) {
        if (editingArrow! < (model.arrowsPerEnd - 1)) {
          editingArrow = editingArrow! + 1;
        }

        notify(ArrowStateChangedEvent(
            participant: participant, end: editingEnd, arrow: editingArrow!));
      });
    }
  }

  void nextArrow(MatchModel model, ParticipantModel participant) {
    bool activeArrowChanged = false;
    if (editingEnd >= 0 && (editingArrow == null)) {
      for (int i = editingArrow! + 1; i < model.arrowsPerEnd; i++) {
        if (participant.ends[editingEnd].arrows[i] == null) {
          editingArrow = i;
          activeArrowChanged = true;
          break;
        }
      }
    }
    if (activeArrowChanged) notifActiveArrowChanged();
  }

  void notifyKeyboardShown() {
    notify(KeyboardShownEvent());
  }

  void notifActiveArrowChanged() {
    notify(ActiveArrowChangedEvent());
  }
}

class ScoresViewmodelLoadedEvent extends ViewEvent {
  final MatchModel model;

  ScoresViewmodelLoadedEvent({required this.model})
      : super("ScoresViewmodelLoadedEvent");
}

class ScoresViewmodelUpdatedEvent extends ViewEvent {
  ScoresViewmodelUpdatedEvent() : super("ScoresViewmodelUpdatedEvent");
}

class KeyboardShownEvent extends ViewEvent {
  KeyboardShownEvent() : super("KeyboardShownEvent");
}

class ActiveArrowChangedEvent extends ViewEvent {
  ActiveArrowChangedEvent() : super("ActiveArrowChangedEvent");
}
