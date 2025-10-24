import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String colorHex;
  final String message;

  // Icon data fields for serialization and comparison
  final int iconCodePoint;
  final String iconFontFamily;
  final String? iconFontPackage;

  // Constructor
  const CategoryEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.colorHex,
    required this.message,
    required this.iconCodePoint,
    this.iconFontFamily = 'MaterialIcons',
    this.iconFontPackage,
  });

  // Getter to get IconData widget from stored data
  IconData get iconData => IconData(
    iconCodePoint,
    fontFamily: iconFontFamily,
    fontPackage: iconFontPackage,
  );

  // Convert hex color string to Color
  Color get color {
    String hex = colorHex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // add alpha if missing
    return Color(int.parse(hex, radix: 16));
  }

  Icon get icon => Icon(iconData);

  // Equatable props: include all important fields (not the Icon widget)
  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    colorHex,
    message,
    iconCodePoint,
    iconFontFamily,
    iconFontPackage,
  ];
}
