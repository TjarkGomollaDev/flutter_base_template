import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final Logger logger;

  AppBlocObserver({required this.logger});

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.d('BlocEvent: ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.t(
        'BlocChange: ${bloc.runtimeType}\nCurrent: ${change.currentState}\nNext: ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.d(
        'BlocTransition: ${bloc.runtimeType} ${transition.event.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e('BlocError: ${bloc.runtimeType}',
        error: error, stackTrace: stackTrace);
  }
}
