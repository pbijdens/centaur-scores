import 'package:centaur_scores/src/mvvm/observer.dart';

class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}