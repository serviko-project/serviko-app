class StringUtils {
  // E.g. "payment_pending" -> "Payment Pending"
  static String formatSnakeCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split('_')
        .map((part) {
          return part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}';
        })
        .join(' ');
  }
}
