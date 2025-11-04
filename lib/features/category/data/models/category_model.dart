import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.colorHex,
    required super.message,
    required super.iconCodePoint,
    required super.iconFontFamily,
    super.iconFontPackage,
  });

  /// Convert model to JSON Map for Firebase storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'colorHex': colorHex,
    'message': message,
    'iconCodePoint': iconCodePoint,
    'iconFontFamily': iconFontFamily,
    'iconFontPackage': iconFontPackage,
  };

  /// Create model from JSON Map
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      colorHex: json['colorHex'],
      message: json['message'],
      iconCodePoint: json['iconCodePoint'] ?? Icons.category.codePoint,
      iconFontFamily: json['iconFontFamily'] ?? 'MaterialIcons',
      iconFontPackage: json['iconFontPackage'],
    );
  }

  /// Convert entity to model
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      colorHex: entity.colorHex,
      message: entity.message,
      iconCodePoint: entity.iconCodePoint,
      iconFontFamily: entity.iconFontFamily,
      iconFontPackage: entity.iconFontPackage,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      userId: userId,
      name: name,
      colorHex: colorHex,
      message: message,
      iconCodePoint: iconCodePoint,
      iconFontFamily: iconFontFamily,
      iconFontPackage: iconFontPackage,
    );
  }
}
