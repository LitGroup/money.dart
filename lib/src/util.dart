/// true if the passed character is a digit.
bool isDigit(String char) {
  if (char.isEmpty) {
    return false;
  }
  final code = char.codeUnitAt(0);

  return code >= 48 && code <= 57;
}
