String emailValidation(String email) {
  if (email.isEmpty || email == null) return 'Email shoold not be empty';

  bool emailVlid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  if (emailVlid == false) return 'Invalid Email';
  return null;
}

String passwordlValidation(String password) {
  if (password == null || password.isEmpty)
    return 'password shoold not be empty';

  if (password.length < 5) return 'password min length is 5';

  // bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  // if (hasUppercase) {
  //   bool hasDigits = password.contains(RegExp(r'[0-9]'));
  //   if (hasDigits) {
  //     bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  //     if (hasLowercase) {
  //       bool hasSpecialCharacters =
  //           password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  //       return hasSpecialCharacters;
  //     }
  //   }
  // }

  return null;
}

String standarTextValidation(String input, String label) {
  if (input.isEmpty || input == null) return '$label shoold not be empty';

  return null;
}
