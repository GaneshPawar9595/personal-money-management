import 'package:flutter/material.dart';
import 'package:money_management/config/localization/app_localizations.dart';
import '../../domain/usecases/calculate_spending_trends_usecase.dart';

/// Reusable time range toggle buttons
class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedRange;
  final ValueChanged<TimeRange> onRangeChanged;
  final List<String>? labels;

  const TimeRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
    this.labels, // If null, use localization
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localizedLabels = [
      loc.translate('this_week'),
      loc.translate('this_month'),
      loc.translate('this_year'),
    ];
    final showLabels = labels ?? localizedLabels;

    return ToggleButtons(
      isSelected: [
        selectedRange == TimeRange.weekly,
        selectedRange == TimeRange.monthly,
        selectedRange == TimeRange.yearly,
      ],
      onPressed: (index) {
        onRangeChanged(TimeRange.values[index]);
      },
      children: showLabels
          .map((label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(label),
      ))
          .toList(),
    );
  }
}
