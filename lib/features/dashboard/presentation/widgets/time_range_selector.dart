import 'package:flutter/material.dart';
import '../../domain/usecases/calculate_spending_trends_usecase.dart';

/// Reusable time range toggle buttons
class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onRangeChanged;
  final List<String> labels;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    this.labels = const ['This Week', 'This Month', 'This Year'],
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [
        selectedRange == TimeRange.weekly,
        selectedRange == TimeRange.monthly,
        selectedRange == TimeRange.yearly,
      ],
      onPressed: (index) {
        onRangeChanged(TimeRange.values[index]);
      },
      children: labels
          .map((label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label),
      ))
          .toList(),
    );
  }
}
