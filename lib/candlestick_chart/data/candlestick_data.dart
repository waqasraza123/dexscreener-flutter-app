import 'dart:math';
import '../candle_data.dart';

/// Generates 30 days of candlestick data
List<CandleData> generateCandlestickData() {
  List<CandleData> data = [];
  Random random = Random();
  double basePrice = 100.0;

  for (int i = 0; i < 30; i++) {
    double open = basePrice + random.nextDouble() * 10;
    double close = basePrice + random.nextDouble() * 10;
    double high = max(open, close) + random.nextDouble() * 5;
    double low = min(open, close) - random.nextDouble() * 5;
    double volume = random.nextDouble() * 500 + 1000;

    data.add(CandleData(
      timestamp: DateTime.now()
          .subtract(Duration(days: 30 - i))
          .millisecondsSinceEpoch,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
    ));

    // Update base price for the next day to keep it random
    basePrice = close;
  }

  return data;
}
