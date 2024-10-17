import 'package:flutter/material.dart';
import '../services/dex_api_service.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DexApiService apiService = DexApiService();
  late Future<List<dynamic>> dexData;

  @override
  void initState() {
    super.initState();
    dexData = apiService.fetchDexData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: dexData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var token = snapshot.data![index];

              // Get percentage and handle parsing
              String percentageString = token['24h'] ?? '0';
              double? percentage = double.tryParse(percentageString.replaceAll('%', ''));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Token logo, symbol, price, 24h change
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // chain logo
                        ClipOval(
                            child: Image.network(
                                token['token']['chainLogoUrl'] ?? '',
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover, // This ensures the image covers the entire circular area
                                errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 40);
                                },
                            ),
                        ),

                        // token chain logo
                        ClipOval(
                            child: Image.network(
                                token['token']['tokenImageUrl'] ?? '',
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, size: 40);
                                },
                            ),
                        ),

                        const SizedBox(width: 8), // Space between logo and text

                        // Token symbol
                        Text(
                          token['token']['tokenSymbol']?.toUpperCase() ?? 'UNKNOWN',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),

                        Spacer(),
                        const SizedBox(width: 16), // Space between symbol and price

                        // Token price
                        Text(
                          token['price']?.toString() ?? '0',
                          style: TextStyle(fontSize: 12),
                        ),

                        const SizedBox(width: 16), // Space between price and 24h percentage

                        // 24-hour percentage change
                        Text(
                          '24h ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          percentageString,
                          style: TextStyle(
                            fontSize: 12,
                            color: (percentage ?? 0) >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8), // Space between rows

                    // Row 2: Chain logo, Token name, LIQ, VOL, MCAP
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // dex logo
                        Image.network(
                          token['token']['dexLogoUrl'] ?? '',
                          height: 20,
                          width: 20,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                        const SizedBox(width: 8), // Space between chain logo and token name

                        // Token name
                        Expanded(
                          child: Text(
                            token['token']['tokenName'] ?? 'Unknown',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8), // Space between name and liquidity

                        // Liquidity (LIQ)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            'LIQ ${token['liquidity'] ?? '0'}',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Volume (VOL)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            'VOL ${token['volume'] ?? '0'}',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(width: 8), // Space between volume and market cap

                        // Market cap (MCAP)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            'MCAP ${token['mcap']?.toString() ?? '0'}',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
