class TextFormValidators {
  static final alphabetRegExp = RegExp(r'^[a-zA-Z\s]+$');
  static final phoneRegExp = RegExp(r'^\d{10}$');
  static final emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final addressRegExp = RegExp(r'^[a-zA-Z0-9\s,.-]+$');

  static String? validatePhoneNumber(String? value) {
    // Check if the value is null
    if (value == null) {
      return 'Phone number cannot be null';
    }

    // Check if the value is empty
    if (value.isEmpty) {
      return 'Phone number cannot be empty';
    }

    // Check if the value contains only digits and is exactly 10 digits long

    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null; // Return null if the phone number is valid
  }

  // Validator function for Pinput
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN cannot be empty';
    } else if (value.length != 6) {
      return 'PIN must be exactly 6 digits';
    }
    return null;
  }

  static String? validateBusinessName(String? value) {
    if (value == null || value.isEmpty) {
      return 'A Business Name is required';
    } else if (!alphabetRegExp.hasMatch(value)) {
      return 'A Business Name must contain only alphabets and spaces';
    } else if (value.length < 2) {
      return 'A Business Name must be at least 2 characters long';
    } else if (value.length > 50) {
      return 'A Business Name must be less than 50 characters';
    }
    return null; // Valid name
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validateBusinessAddress(String? value) {
    const int minLength = 5;

    if (value == null || value.trim().isEmpty) {
      return 'Business address cannot be empty';
    }

    if (value.trim().length < minLength) {
      return 'Business address must be at least $minLength characters long';
    }

    if (!addressRegExp.hasMatch(value.trim())) {
      return 'Invalid characters in the business address';
    }

    return null;
  }

  static String? validateCaption(String? value) {
    String pattern = r'^[a-zA-Z0-9\s]+$';
    RegExp regex = RegExp(pattern);

    if (value == null || !regex.hasMatch(value)) {
      return 'Caption must contain only alphabets, numbers, and spaces';
    } else if (value.length < 2) {
      return 'Caption must be at least 2 characters long';
    } else if (value.length > 80) {
      return 'Caption must be less than 80 characters';
    }
    return null;
  }

  static String? validateMenuItemName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Item name cannot be empty';
    }
    if (!alphabetRegExp.hasMatch(value)) {
      return 'Item name can only contain alphabets and spaces';
    }
    if (value.length > 20) {
      return 'Item name cannot be longer than 20 characters';
    }

    return null;
  }

  static String? validateItemDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description cannot be empty';
    }
    if (value.length > 100) {
      return 'Description cannot exceed 100 characters';
    }
    if (!alphabetRegExp.hasMatch(value)) {
      return 'Description can only contain alphabets and spaces';
    }
    return null;
  }

  static String? validateItemPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price cannot be empty';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Enter a valid numeric value';
    }

    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }


}
