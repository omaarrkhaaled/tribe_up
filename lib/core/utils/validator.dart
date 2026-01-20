class Validator {
  static String? validateEmail(String? val) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (val == null) {
      return 'This field is required';
    } else if (val.trim().isEmpty) {
      return 'This field is required';
    } else if (emailRegex.hasMatch(val) == false) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'This field is required';
    } else if (val.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'[A-Z]').hasMatch(val)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'[a-z]').hasMatch(val)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!RegExp(r'[!@#\$&*~%^()\-_+=<>?/.,;:{}|]').hasMatch(val)) {
      return 'Password must contain at least one special character';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String? val, String? password) {
    if (val == null || val.isEmpty) {
      return 'This field is required';
    } else if (val != password) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    final username = value.trim();

    if (username.length < 4 || username.length > 20) {
      return 'Username must be 4–20 characters';
    }

    final validRegex = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!validRegex.hasMatch(username)) {
      return 'Only letters, numbers, _ and . are allowed';
    }

    if (username.startsWith('_') ||
        username.startsWith('.') ||
        username.endsWith('_') ||
        username.endsWith('.')) {
      return 'Username cannot start or end with . or _';
    }

    if (username.contains('..') || username.contains('__')) {
      return 'Username cannot contain repeated symbols';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final nameRegex = RegExp(r'^[A-Za-z]+$');

    if (!nameRegex.hasMatch(value.trim())) {
      return 'Only letters are allowed';
    }

    return null;
  }

  static String? validatePhoneNumber(String? val) {
    if (val == null) {
      return 'This field is required';
    } else if (int.tryParse(val.trim()) == null) {
      return 'Enter numbers only';
    } else if (val.trim().length != 11) {
      return 'Enter value must equal 11 digit';
    } else {
      return null;
    }
  }

  static String? validateRequired(String? val) {
    if (val == null || val.isEmpty) {
      return 'This field is required';
    } else {
      return null;
    }
  }
}
