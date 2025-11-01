/// This class contains different methods to check (validate)
/// if the information entered by the user (like name, phone, email, password)
/// is correct or not.
class Validators {

  /// This method checks if the "Name" entered by the user is valid.
  ///
  /// - If the name is empty → it returns the "name required" message.
  /// - If the name doesn't match the required pattern → it returns the "name invalid" message.
  /// - If everything is okay → it returns null (means no error).
  static String? validateName(String? value, String nameRequiredMsg, String nameInvalidMsg) {
    // Check if the name is empty or null
    if (value == null || value.trim().isEmpty) {
      return nameRequiredMsg; // show "name is required" message
    }

    // Regex for multiple words:
    // Each word: starts and ends with a letter, may include hyphens or apostrophes inside.
    // Words separated by a single space.
    final namePattern = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?:[ '-][A-Za-zÀ-ÖØ-öø-ÿ]+)*$");

    // Check against pattern
    if (!namePattern.hasMatch(value.trim())) {
      return nameInvalidMsg; // show "invalid name" message
    }

    // If no problems found, return null (means valid)
    return null;
  }


  /// This method checks if the "Phone Number" entered by the user is valid.
  ///
  /// - If the phone number is empty → it returns the "phone required" message.
  /// - If the phone number is not exactly 10 digits → it returns the "phone invalid" message.
  /// - If everything is okay → it returns null.
  static String? validatePhone(String? value, String phoneRequiredMsg, String phoneInvalidMsg) {
    // Check if phone number is empty or null
    if (value == null || value.trim().isEmpty == true) {
      return phoneRequiredMsg; // show "phone number required" message
    }

    // Check if phone number has exactly 10 digits
    if (RegExp(r'^[0-9]{10}$').hasMatch(value) == false) {
      return phoneInvalidMsg; // show "invalid phone number" message
    }

    // If no problems found, return null (means valid)
    return null;
  }

  /// This method checks if the "Email" entered by the user is valid.
  ///
  /// - If the email is empty → it returns the "email required" message.
  /// - If the email format is wrong (e.g. missing @ or .com) → it returns the "invalid email" message.
  /// - If everything is okay → it returns null.
  static String? validateEmail(String? value, String emailRequiredMsg, String invalidEmailMsg) {
    // Check if email is empty or null
    if (value == null || value.trim().isEmpty) {
      return emailRequiredMsg; // show "email required" message
    }

    // Check if email follows a valid pattern (e.g. example@domain.com)
    if (RegExp(r'^[\w-.]+@([\w-]+\.)+\w{2,4}').hasMatch(value) == false) {
      return invalidEmailMsg; // show "invalid email" message
    }

    // If no problems found, return null (means valid)
    return null;
  }

  /// This method checks if the "Password" entered by the user is valid.
  ///
  /// - If the password has less than 6 characters → it returns the "password too short" message.
  /// - If everything is okay → it returns null.
  static String? validatePassword(String? value, String passwordTooShortMsg) {
    // Check if password is null or has less than 6 characters
    if (value == null || value.length < 6) {
      return passwordTooShortMsg; // show "password too short" message
    }

    // If no problems found, return null (means valid)
    return null;
  }

  static String? validateCategoryName(String? value, String errorMessage){
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }
}