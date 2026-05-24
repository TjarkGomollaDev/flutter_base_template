import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_local_datasources/interface_app_settings_local_datasource.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final InterfaceAppSettingsLocalDatasource _appSettingsLocalDatasource;

  SearchBloc({required InterfaceAppSettingsLocalDatasource appSettingsLocalDatasource})
      : _appSettingsLocalDatasource = appSettingsLocalDatasource,
        super(SearchState.initial(recentSearches: appSettingsLocalDatasource.getRecentSearches())) {
    on<SearchEventUpdateSearch>(_onUpdateSearch);
    on<SearchEventSubmitSearch>(_onSubmitSearch);
    on<SearchEventResetRecentSearches>(_onResetRecentSearches);
  }

  void _onUpdateSearch(SearchEventUpdateSearch event, Emitter<SearchState> emit) {
    emit(state.copyWith(searchTerm: event.searchTerm));
  }

  void _onSubmitSearch(SearchEventSubmitSearch event, Emitter<SearchState> emit) {
    final recentSearches = state.recentSearches.toList();
    if (recentSearches.length >= 5) recentSearches.removeAt(0);
    recentSearches.add(state.searchTerm);
    _appSettingsLocalDatasource.setRecentSearches(recentSearches: recentSearches);
    emit(state.copyWith(recentSearches: recentSearches));
  }

  void _onResetRecentSearches(SearchEventResetRecentSearches event, Emitter<SearchState> emit) {
    _appSettingsLocalDatasource.resetRecentSearches();
  }
}
