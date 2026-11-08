extension StringExtensions on String {
  List<bool> isLowerCase() {
    if (isEmpty) {
      throw ArgumentError('String is empty.');
    }
    final result = <bool>[];
    for (var i = 0; i < length; i++) {
      final isLower =
          this[i] == this[i].toLowerCase() &&
          this[i].toLowerCase() != this[i].toUpperCase();
      result.add(isLower);
    }
    return result;
  }
}
