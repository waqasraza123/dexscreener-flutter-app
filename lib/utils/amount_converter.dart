double convertToReadableAmount(dynamic amount) {
  // Convert the input to double if it's a String
  double numericAmount;
  if (amount is String) {
    numericAmount =
        double.tryParse(amount) ?? 0.0; // Fallback to 0.0 if parsing fails
  } else if (amount is double) {
    numericAmount = amount;
  } else {
    return 0.0; // Return 0.0 for unsupported types
  }

  if (numericAmount >= 1e12) {
    return numericAmount / 1e12; // Trillions
  } else if (numericAmount >= 1e9) {
    return numericAmount / 1e9; // Billions
  } else if (numericAmount >= 1e6) {
    return numericAmount / 1e6; // Millions
  } else if (numericAmount >= 1e3) {
    return numericAmount / 1e3; // Thousands
  }
  return numericAmount; // Less than a thousand
}

String formatAmount(dynamic amount) {
  // Convert the input to double if it's a String
  double numericAmount;
  if (amount is String) {
    numericAmount =
        double.tryParse(amount) ?? 0.0; // Fallback to 0.0 if parsing fails
  } else if (amount is double) {
    numericAmount = amount;
  } else {
    return '0'; // Return '0' for unsupported types
  }

  String suffix;
  double convertedAmount;

  if (numericAmount >= 1e12) {
    suffix = 'T'; // Trillion
    convertedAmount = numericAmount / 1e12;
  } else if (numericAmount >= 1e9) {
    suffix = 'B'; // Billion
    convertedAmount = numericAmount / 1e9;
  } else if (numericAmount >= 1e6) {
    suffix = 'M'; // Million
    convertedAmount = numericAmount / 1e6;
  } else if (numericAmount >= 1e3) {
    suffix = 'K'; // Thousand
    convertedAmount = numericAmount / 1e3;
  } else {
    suffix = ''; // No suffix
    convertedAmount = numericAmount;
  }

  return '${convertedAmount.toStringAsFixed(2)}$suffix';
}
