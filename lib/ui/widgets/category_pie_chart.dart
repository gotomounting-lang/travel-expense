import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../util/money.dart';

/// 카테고리별 원화 지출 파이차트와 범례.
class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({super.key, required this.totals});

  /// 금액이 큰 순서로 정렬된 카테고리별 원화 합계.
  final Map<ExpenseCategory, int> totals;

  @override
  Widget build(BuildContext context) {
    final sum = totals.values.fold<int>(0, (s, v) => s + v);
    if (sum == 0) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('원화로 환산된 지출이 아직 없습니다')),
      );
    }
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 36,
              sectionsSpace: 2,
              sections: [
                for (final e in totals.entries)
                  PieChartSectionData(
                    value: e.value.toDouble(),
                    color: e.key.color,
                    radius: 42,
                    title: e.value / sum >= 0.08
                        ? '${(e.value * 100 / sum).round()}%'
                        : '',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in totals.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: e.key.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.key.label,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        formatKrw(e.value),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
