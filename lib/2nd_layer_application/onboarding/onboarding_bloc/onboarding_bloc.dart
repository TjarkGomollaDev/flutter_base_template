import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  OnboardingBloc({required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource,
        super(const OnboardingState()) {
    on<OnboardingEventChangePageIndex>(_onChangePageIndex);
    on<OnboardingEventFinishOnboarding>(_onFinishOnboarding);
  }

  void _onChangePageIndex(OnboardingEventChangePageIndex event, Emitter<OnboardingState> emit) {
    emit(OnboardingState(index: event.index));
  }

  Future<void> _onFinishOnboarding(
      OnboardingEventFinishOnboarding event, Emitter<OnboardingState> emit) async {
    await _appSettingsLocalDatasource.setDeviceOpenFirstTime(value: false);
  }
}
