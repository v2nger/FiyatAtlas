import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/price_entry.dart';

class PriceChart extends StatelessWidget {
  const PriceChart({super.key, required this.history});

  final List<PriceEntry> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    // Veriyi hazırla: Tarihe göre sırala
    final sortedData = List<PriceEntry>.from(history);
    sortedData.sort((a, b) => a.entryDate.compareTo(b.entryDate));

    // X ekseni için tarihleri ve değerleri hazırla
    final firstDate = sortedData.first.entryDate;
    
    // Chart noktaları oluştur
    final List<FlSpot> spots = sortedData.map((e) {
      // Başlangıç tarihine göre geçen gün sayısı (double olarak)
      final diff = e.entryDate.difference(firstDate).inMinutes.toDouble();
      return FlSpot(diff, e.price);
    }).toList();

    // Min-Max Y (Fiyat)
    double minY = sortedData.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    double maxY = sortedData.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    minY = (minY * 0.9).floorToDouble();
    maxY = (maxY * 1.1).ceilToDouble();

    // X Ekseni aralığı (Dakika cinsinden)
    double maxX = spots.last.x;
    if (maxX == 0) maxX = 1; // Tek veri varsa hata vermesin

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Son 30 Günlük Fiyat Değişimi", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => 
                  FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true, 
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}₺', style: const TextStyle(fontSize: 10, color: Colors.grey));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxX / 3) == 0 ? 1 : (maxX / 3), // En fazla 3-4 tarih göster
                    getTitlesWidget: (value, meta) {
                       if (value < 0 || value > maxX) return const SizedBox.shrink();
                       
                       final date = firstDate.add(Duration(minutes: value.toInt()));
                       return Padding(
                         padding: const EdgeInsets.only(top: 8.0),
                         child: Text(
                           DateFormat('d MMM').format(date), 
                           style: const TextStyle(fontSize: 10, color: Colors.grey),
                         ),
                       );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.teal,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.teal,
                      );
                    }
                  ),
                  belowBarData: BarAreaData(
                    show: true, 
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.withValues(alpha: 0.3),
                        Colors.teal.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                   getTooltipItems: (touchedSpots) {
                     return touchedSpots.map((spot) {
                       final date = firstDate.add(Duration(minutes: spot.x.toInt()));
                       return LineTooltipItem(
                         '${spot.y} ₺\n${DateFormat('dd/MM HH:mm').format(date)}',
                         const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                       );
                     }).toList();
                   },
                   fitInsideHorizontally: true,
                   fitInsideVertically: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
