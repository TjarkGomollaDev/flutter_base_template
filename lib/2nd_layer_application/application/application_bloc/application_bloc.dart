import 'package:bloc/bloc.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';
import 'package:meta/meta.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  ApplicationBloc({required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource,
        super(ApplicationState._(index: appSettingsLocalDatasource.getApplicationIndex())) {
    on<ApplicationEventChangePageIndex>(_onChangePageIndex);
    on<ApplicationEventResetPageIndex>(_onResetStateToInitial);
  }

  void _onChangePageIndex(ApplicationEventChangePageIndex event, Emitter<ApplicationState> emit) {
    _appSettingsLocalDatasource.setApplicationIndex(value: event.index);
    emit(ApplicationState._(index: event.index));
  }

  void _onResetStateToInitial(
      ApplicationEventResetPageIndex event, Emitter<ApplicationState> emit) {
    _appSettingsLocalDatasource.resetApplicationIndex();
  }
}
