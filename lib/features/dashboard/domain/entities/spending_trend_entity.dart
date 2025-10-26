/// This tiny record tells a chart how much was spent in a certain time slot
/// (like a day, a month, or a whole year) and what label to show on screen. [web:101][web:104]
class SpendingTrendEntity {
  /// The time slot as a simple number:
  /// - For a week: 0 to 6 (days)
  /// - For a month: YYYYMM (like 202510 for Oct 2025)
  /// - For a year: YYYY (like 2025) [web:101][web:104]
  final int key; // [web:101][web:104]

  /// How much was spent in this time slot; this number is “in thousands” for easy charting. [web:101][web:104]
  final double amount; // [web:101][web:104]

  /// What to show on the chart (“Mon”, “Oct”, or “2025”) so people can read it easily. [web:101][web:104]
  final String label; // [web:101][web:104]

  /// Creates this record; once made, the values stay the same to keep charts consistent. [web:101][web:104]
  const SpendingTrendEntity({
    required this.key,
    required this.amount,
    required this.label,
  }); // [web:101][web:104]

  /// Two records are treated as the same if their time slot, amount, and label all match.
  /// This helps lists and charts avoid duplicates. [web:113][web:115]
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SpendingTrendEntity &&
              runtimeType == other.runtimeType &&
              key == other.key &&
              amount == other.amount &&
              label == other.label; // [web:113][web:115]

  /// A matching partner for equality so sets/maps work correctly. [web:115][web:116]
  @override
  int get hashCode => key.hashCode ^ amount.hashCode ^ label.hashCode; // [web:115][web:116]
}
