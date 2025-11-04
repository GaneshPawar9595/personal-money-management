import 'package:flutter/material.dart';

import '../../features/dashboard/domain/usecases/calculate_spending_trends_usecase.dart';

DateTimeRange getDateRangeForTimeRange(TimeRange range) {
  final now = DateTime.now();
  late DateTime start;
  late DateTime end;

  switch (range) {
    case TimeRange.weekly:
      final weekday = now.weekday;
      start = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
      end = start.add(const Duration(days: 7));
      break;
    case TimeRange.monthly:
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
      break;
    case TimeRange.yearly:
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year, 12, 31);
      break;
  }
  return DateTimeRange(start: start, end: end);
}