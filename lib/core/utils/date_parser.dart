import 'dart:developer';

class DateParser {
  static DateTime parseLocal(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now();

    String normalized = dateStr.trim();

    final hasUtcSuffix = normalized.endsWith('Z') || normalized.endsWith('z');

    bool hasOffset = false;
    final tIndex = normalized.indexOf('T');
    if (tIndex != -1) {
      final timePart = normalized.substring(tIndex);
      hasOffset = timePart.contains('+') || timePart.contains('-');
    } else {
      final spaceIndex = normalized.indexOf(' ');
      if (spaceIndex != -1) {
        final timePart = normalized.substring(spaceIndex);
        hasOffset = timePart.contains('+') || timePart.contains('-');
      }
    }

    if (!hasUtcSuffix && !hasOffset) {
      normalized = '${normalized}Z';
    }

    try {
      final parsed = DateTime.tryParse(normalized);
      if (parsed != null) {
        return parsed.toLocal();
      }
    } catch (e, stackTrace) {
      log('Error parsing date: $dateStr', error: e, stackTrace: stackTrace);
    }

    return DateTime.now();
  }
}
