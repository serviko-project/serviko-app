// Form Validators
class FormValidators {
  const FormValidators._();

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Validates that a required field is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  // Validates an Email Field
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validates a Password Field
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validates Confirm Password Field
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Validates an optional phone number field
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid 10-digit number';
    }
    return null;
  }

  // Validates a required numeric field
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (num.tryParse(value.trim()) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  // Validates Promo Code
  static String? validatePromoCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Promo code is required";
    }
    if (value.trim().length < 3) {
      return "Code must be at least 3 characters";
    }
    return null;
  }

  // Validates Discount Value
  static String? validateDiscountValue(String? value, String discountType) {
    if (value == null || value.trim().isEmpty) {
      return "Value required";
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return "Must be greater than 0";
    }
    if (discountType == 'percentage' && parsed > 100) {
      return "Max 100%";
    }
    return null;
  }

  // Validates Optional Minimum Amount
  static String? validateOptionalMinAmount(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final parsed = double.tryParse(value);
      if (parsed == null || parsed < 0) {
        return "Must be greater than or equal to 0";
      }
    }
    return null;
  }

  // Validates Optional Max Uses
  static String? validateOptionalMaxUses(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final parsed = int.tryParse(value);
      if (parsed == null || parsed <= 0) {
        return "Must be positive number";
      }
    }
    return null;
  }
}
