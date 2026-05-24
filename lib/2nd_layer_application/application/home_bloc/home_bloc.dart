import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';
import 'package:mark_lxxxv/core/extensions/string_extensions.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final InterfaceUserRepository _userRepository;
  late String username;
  late List<String> letters;

  HomeBloc({required InterfaceUserRepository userRepository})
      : _userRepository = userRepository,
        super(HomeState.initial()) {
    on<HomeEventStart>(_onStart);
    on<_HomeEventUpdateDisplayUsername>(_onUpdateDisplayUsername);
    on<HomeEventChangeMenuChipsIndex>(_onChangeMenuChipsIndex);
    on<HomeEventChangeCardStatus>(_onChangeCardStatus);
    shuffleUsername();
  }

  void _onStart(HomeEventStart event, Emitter<HomeState> emit) {}

  void _onUpdateDisplayUsername(_HomeEventUpdateDisplayUsername event, Emitter<HomeState> emit) {
    emit(state.copyWith(usernameAnimation: letters.join()));
  }

  void _onChangeMenuChipsIndex(HomeEventChangeMenuChipsIndex event, Emitter<HomeState> emit) {
    emit(state.copyWith(menuChipsIndex: event.index));
  }

  void _onChangeCardStatus(HomeEventChangeCardStatus event, Emitter<HomeState> emit) {
    emit(state.copyWith(cardStatus: !state.cardStatus));
  }

  void shuffleUsername() async {
    username = 'Maurice999';
    letters = List<String>.filled(username.length, '');
    final isLetterLowerCase = username.isLowerCase();
    for (var i = 0; i < username.length; i++) {
      _changeLetter(position: i, isLowerCase: isLetterLowerCase[i]);
    }
  }

  Future<void> _changeLetter({required int position, required bool isLowerCase}) async {
    for (var i = 0; i < 10 + position * 5; i++) {
      letters[position] = _randomLetter(isLowerCase: isLowerCase);
      add(_HomeEventUpdateDisplayUsername());
      await Future.delayed(const Duration(milliseconds: 55));
    }
    letters[position] = username[position];
    add(_HomeEventUpdateDisplayUsername());
  }

  String _randomLetter({required bool isLowerCase}) {
    // choose a random number between 'A' (65) and 'Z' (90) (unicode values)
    final randomNumber = Random().nextInt(26) + 'A'.codeUnitAt(0);
    if (isLowerCase) {
      return String.fromCharCode(randomNumber).toLowerCase();
    }
    return String.fromCharCode(randomNumber);
  }
}
