part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {
  const SearchEvent();
}

class SearchEventUpdateSearch extends SearchEvent {
  final String searchTerm;

  const SearchEventUpdateSearch({
    required this.searchTerm,
  });
}

class SearchEventSubmitSearch extends SearchEvent {}

class SearchEventResetRecentSearches extends SearchEvent {}
