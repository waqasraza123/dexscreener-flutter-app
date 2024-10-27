import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tokens.length,
              itemBuilder: (context, index) {
                final token = tokens[index];
                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading:
                        Image.network(token['image'], width: 40, height: 40),
                    title: Text(token['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Symbol, Price, Market Cap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Symbol: ${token['symbol']}",
                                style: TextStyle(fontSize: 12)),
                            Text(
                                "Price: \$${formatAmount(token['current_price'])}",
                                style: TextStyle(fontSize: 12)),
                            Text(
                                "Market Cap: \$${formatAmount(token['market_cap'])}",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Row 2: 24h Change, ATH, Circulating Supply
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "24h: ${token['price_change_percentage_24h']?.toStringAsFixed(2) ?? 'N/A'}%",
                                style: TextStyle(fontSize: 12)),
                            Text("ATH: \$${formatAmount(token['ath'])}",
                                style: TextStyle(fontSize: 12)),
                            Text(
                                "Supply: ${formatAmount(token['circulating_supply'])}",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
