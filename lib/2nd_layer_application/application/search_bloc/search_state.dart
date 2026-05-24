part of 'search_bloc.dart';

@immutable
class SearchState {
  final List<String> recentSearches;
  final String searchTerm;

  const SearchState._({
    required this.recentSearches,
    required this.searchTerm,
  });

  factory SearchState.initial({required List<String> recentSearches}) {
    return SearchState._(
      recentSearches: recentSearches,
      searchTerm: '',
    );
  }

  SearchState copyWith({
    List<String>? recentSearches,
    String? searchTerm,
  }) {
    return SearchState._(
      recentSearches: recentSearches ?? this.recentSearches,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
