import 'package:flutter/material.dart';
import '../services/dex_api_service.dart';
import '../utils/colors.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  DataScreenState createState() => DataScreenState();
}

class DataScreenState extends State<DataScreen> {
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
              double? percentage =
                  double.tryParse(percentageString.replaceAll('%', ''));

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Token logo, symbol, price, 24h change
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // token logo
                        ClipOval(
                          child: Image.network(
                            token['token']['tokenImageUrl'] ?? '',
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 20);
                            },
                          ),
                        ),

                        const SizedBox(width: 8), // Space

                        // Token symbol and chain symbol
                        Row(
                          children: [
                            Text(
                              token['token']['tokenSymbol']?.toUpperCase() ??
                                  'UNKNOWN',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width: 4), // Optional space between symbols
                            const Text(
                              '/',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                                width: 4), // Optional space between symbols
                            Text(
                              token['token']['chainSymbol']?.toUpperCase() ??
                                  'UNKNOWN',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const Spacer(),
                        const SizedBox(width: 16), // Space

                        // Token price
                        Text(
                          token['price']?.toString() ?? '0',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(width: 16), // Space

                        // 24-hour percentage change
                        const Text(
                          '24h ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          percentageString,
                          style: TextStyle(
                              fontSize: 12,
                              color: (percentage ?? 0) >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8), // Space between rows

                    // Row 2: Dex logo, Token full name, LIQ, VOL, MCAP
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // dex logo
                        Image.network(
                          token['token']['dexLogoUrl'] ?? '',
                          height: 20,
                          width: 20,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 20);
                          },
                        ),
                        const SizedBox(width: 8), // Space

                        // Token name
                        Expanded(
                          child: Text(
                            token['token']['tokenName'] ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8), // Space

                        // Liquidity (LIQ)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'LIQ ',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                '${token['liquidity'] ?? '0'}',
                                style: const TextStyle(
                                    fontSize: 10, color: customBlack),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Volume (VOL)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'VOL ',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                token['volume'] ?? '0',
                                style: const TextStyle(
                                    fontSize: 10, color: customBlack),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8), // Space

                        // Market cap (MCAP)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'MCAP ',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                token['mcap']?.toString() ?? '0',
                                style: const TextStyle(
                                    fontSize: 10, color: customBlack),
                              ),
                            ],
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
