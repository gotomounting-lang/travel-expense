import 'package:flutter/material.dart';

/// 지출 카테고리. [id]는 DB와 시트에 저장되는 값이라 바꾸면 안 된다.
enum ExpenseCategory {
  food('food', '음식', Icons.restaurant, Color(0xFFE4572E)),
  snack('snack', '간식/카페', Icons.local_cafe, Color(0xFFF3A712)),
  souvenir('souvenir', '기념품', Icons.card_giftcard, Color(0xFF8E44AD)),
  shopping('shopping', '쇼핑', Icons.shopping_bag, Color(0xFFD81B60)),
  transport('transport', '교통', Icons.directions_bus, Color(0xFF2E86AB)),
  lodging('lodging', '숙박', Icons.hotel, Color(0xFF3D5A80)),
  sightseeing('sightseeing', '관광/입장료', Icons.attractions, Color(0xFF29A36A)),
  other('other', '기타', Icons.more_horiz, Color(0xFF7F8C8D));

  const ExpenseCategory(this.id, this.label, this.icon, this.color);

  final String id;
  final String label;
  final IconData icon;
  final Color color;

  static ExpenseCategory fromId(String id) => ExpenseCategory.values.firstWhere(
    (c) => c.id == id,
    orElse: () => ExpenseCategory.other,
  );
}
