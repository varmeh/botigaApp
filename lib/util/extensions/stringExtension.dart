extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      this.toLowerCase().contains(secondString.toLowerCase());

  bool get isUrl => this != null && this.startsWith('https://');
}
