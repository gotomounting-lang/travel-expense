import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// 지출 카테고리. [id]는 DB와 시트에 저장되는 값이라 바꾸면 안 된다.
enum ExpenseCategory {
  food('food', Icons.restaurant, Color(0xFFE4572E)),
  snack('snack', Icons.local_cafe, Color(0xFFF3A712)),
  souvenir('souvenir', Icons.card_giftcard, Color(0xFF8E44AD)),
  shopping('shopping', Icons.shopping_bag, Color(0xFFD81B60)),
  transport('transport', Icons.directions_bus, Color(0xFF2E86AB)),
  lodging('lodging', Icons.hotel, Color(0xFF3D5A80)),
  sightseeing('sightseeing', Icons.attractions, Color(0xFF29A36A)),
  other('other', Icons.more_horiz, Color(0xFF7F8C8D));

  const ExpenseCategory(this.id, this.icon, this.color);

  final String id;
  final IconData icon;
  final Color color;

  String label(AppLocalizations l) => switch (this) {
    food => l.catFood,
    snack => l.catSnack,
    souvenir => l.catSouvenir,
    shopping => l.catShopping,
    transport => l.catTransport,
    lodging => l.catLodging,
    sightseeing => l.catSightseeing,
    other => l.catOther,
  };

  static ExpenseCategory fromId(String id) => ExpenseCategory.values.firstWhere(
    (c) => c.id == id,
    orElse: () => ExpenseCategory.other,
  );
}
