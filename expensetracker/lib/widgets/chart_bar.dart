import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeExpenseChart extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const IncomeExpenseChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text("Income");
                  case 1:
                    return const Text("Expense");
                  default:
                    return const Text("");
                }
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: totalIncome, color: Colors.green),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: totalExpense, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}
