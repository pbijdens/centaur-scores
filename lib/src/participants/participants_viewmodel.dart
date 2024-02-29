import 'package:centaur_scores/src/model/repository.dart';
import 'package:centaur_scores/src/mvvm/events/loading_event.dart';
import 'package:centaur_scores/src/mvvm/observer.dart';
import 'package:centaur_scores/src/mvvm/viewmodel.dart';

import '../model/group_info.dart';
import '../model/match_model.dart';
import '../model/participant_model.dart';

class ParticipantsViewmodel extends EventViewModel {
  final MatchRepository _repository;

  ParticipantsViewmodel(this._repository);

  void setParticipantName(ParticipantModel participant, String name) {
    _repository.setParticipantName(participant.id, name);
    notify(ParticipantPropertyChangedEvent(
        participant: participant,
        property: ParticipantPropertyChangedEvent.propertyName));
  }

  void setParticipantGroup(ParticipantModel participant, GroupInfo group) {
    _repository.setParticipantGroup(participant.id, group);
    notify(ParticipantPropertyChangedEvent(
        participant: participant,
        property: ParticipantPropertyChangedEvent.propertyGroup));
  }

  void setParticipantSubgroup(
      ParticipantModel participant, GroupInfo subgroup) {
    _repository.setParticipantSubgroup(participant.id, subgroup);
    notify(ParticipantPropertyChangedEvent(
        participant: participant,
        property: ParticipantPropertyChangedEvent.propertySubgroup));
  }

  void load() {
    notify(LoadingEvent(isLoading: true));
    _repository.getModel().then((value) {
      notify(ParticipantsViewmodelLoadedEvent(model: value));
      notify(LoadingEvent(isLoading: false));
    });
  }
}

class ParticipantsViewmodelLoadedEvent extends ViewEvent {
  final MatchModel model;

  ParticipantsViewmodelLoadedEvent({required this.model})
      : super("ParticipantsViewmodelLoadedEvent");
}

class ParticipantPropertyChangedEvent extends ViewEvent {
  static const String propertyName = "name";
  static const String propertyGroup = "group";
  static const String propertySubgroup = "sungroup";

  ParticipantModel participant;
  String property;

  ParticipantPropertyChangedEvent(
      {required this.participant, required this.property})
      : super("ParticipantsViewmodelLoadedEvent");
}
