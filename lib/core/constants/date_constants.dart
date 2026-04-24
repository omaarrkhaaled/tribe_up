class DateConstants {
  static String formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    final timeStr = formatTime(date);
    final monthStr = getMonthName(date.month);
    return '$timeStr • $monthStr ${date.day}, ${date.year}';
  }

  static String formatTime(DateTime date) {
    int hour = date.hour;
    final String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final minuteStr = date.minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }

  static String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
