import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final Logger logger;

  const AppBlocObserver({required this.logger});

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (!kDebugMode) return;
    logger.d('BlocEvent: ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (!kDebugMode) return;
    logger.d(
      'BlocChange: ${bloc.runtimeType}\nCurrent: ${change.currentState}\nNext: ${change.nextState}',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (!kDebugMode) return;
    logger.d(
      'BlocTransition: ${bloc.runtimeType} ${transition.event.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e(
      'BlocError: ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
