extension Validations on String {
  bool isValidName() {
    return RegExp(r'^[a-zA-Z\s.]*$').hasMatch(this);
  }

  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
        .hasMatch(this);
  }
}
