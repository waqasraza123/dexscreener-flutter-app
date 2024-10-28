import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../services/coin_gecko_service.dart';
import '../../../utils/amount_converter.dart';

class GeckoTokensScreen extends StatefulWidget {
  const GeckoTokensScreen({super.key});

  @override
  State<GeckoTokensScreen> createState() => _GeckoTokensScreenState();
}

class _GeckoTokensScreenState extends State<GeckoTokensScreen> {
  final CoinGeckoService _coinGeckoService = CoinGeckoService();
  List<dynamic> tokens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTokens();
  }

  Future<void> fetchTokens() async {
    try {
      final data = await _coinGeckoService.fetchTokens();
      setState(() {
        tokens = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }

    Logger logger = Logger();
    logger.i(tokens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tokens.length,
              itemBuilder: (context, index) {
                final token = tokens[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the SingleTokenScreen with token details (assuming screen exists)
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SingleTokenScreen(token: token),
                    //   ),
                    // );
                  },
                  child: Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First row: Symbol, Price, and 24h Change
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.network(
                                  token['image'] ?? '',
                                  height: 24,
                                  width: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 24);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                token['symbol']?.toUpperCase() ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                "\$${formatAmount(token['current_price'])}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${token['price_change_percentage_24h']?.toStringAsFixed(2) ?? 'N/A'}%",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (token['price_change_percentage_24h'] ??
                                                  0) >=
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Second row: Circulating Supply and Total Supply
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStat("Circ. Supply",
                                  token['circulating_supply'] ?? '0'),
                              _buildStat(
                                  "Total Supply", token['total_supply'] ?? '0'),
                              _buildStat("MCAP",
                                  token['market_cap']?.toString() ?? '0'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStat(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(width: 4),
          Text(
            formatAmount(value),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
