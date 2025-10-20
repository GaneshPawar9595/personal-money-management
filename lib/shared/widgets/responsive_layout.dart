import 'package:flutter/material.dart';

/// 🌐 **ResponsiveLayout**
///
/// A reusable widget that shows **different layouts depending on screen width**.
/// This helps create a responsive UI that looks good on:
/// - Mobile phones
/// - Tablets
/// - Desktop / wide screens
///
/// Usage: Wrap your screen widgets inside this and provide layouts for each size.
class ResponsiveLayout extends StatelessWidget {
  /// Layout to show on small screens (less than 600px wide)
  final Widget mobileLayout;

  /// Layout to show on medium screens (600px - 1024px)
  final Widget tabletLayout;

  /// Layout to show on large screens (more than 1024px)
  final Widget desktopLayout;

  const ResponsiveLayout({
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
    Key? key,
  }) : super(key: key);

  /// 🔹 Helper method to check if the current screen is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// 🔹 Helper method to check if the current screen is tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1024;

  /// 🔹 Helper method to check if the current screen is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder provides the constraints of the parent widget
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Small screen → Mobile layout
          return mobileLayout;
        } else if (constraints.maxWidth < 1024) {
          // Medium screen → Tablet layout
          return tabletLayout;
        } else {
          // Large screen → Desktop layout
          return desktopLayout;
        }
      },
    );
  }
}
