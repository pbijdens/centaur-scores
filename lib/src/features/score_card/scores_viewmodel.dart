import 'package:centaur_scores/src/repository/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/mvvm/viewmodel.dart';

import '../../model/match_model.dart';

class ScoresViewmodel extends EventViewModel {
  final MatchRepository _repository;

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
}

class ScoresViewmodelLoadedEvent extends ViewEvent {
  final MatchModel model;

  ScoresViewmodelLoadedEvent({required this.model})
      : super("ScoresViewmodelLoadedEvent");
}

class ScoresViewmodelUpdatedEvent extends ViewEvent {
  ScoresViewmodelUpdatedEvent() : super("ScoresViewmodelUpdatedEvent");
}
