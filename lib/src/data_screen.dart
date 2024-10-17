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
        title: const Text('DexScreener Coins'),
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

          // Using LayoutBuilder to handle different screen sizes
          return LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: screenWidth),
                    child: DataTable(
                      columnSpacing: 5, // Reduce spacing between columns
                      columns: [
                        DataColumn(label: SizedBox(width: 100, child: Text('Token'))), // Token column
                        DataColumn(label: SizedBox(width: 30, child: Text('Vol.'))),
                        DataColumn(label: SizedBox(width: 50, child: Text('24h'))),
                      ],
                      rows: snapshot.data!.map((token) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the image
                                children: [
                                  // Token logo
                                  Image.network(
                                    token['token']['tokenImageUrl'] ?? '',
                                    height: 40,
                                    width: 40,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                  const SizedBox(width: 8), // Space between logo and text
                                  // Token name and market cap in a column
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (token['token']['tokenName'] ?? 'Unknown').length >= 3
                                            ? (token['token']['tokenName'] ?? 'Unknown')
                                                .substring(0, 3)
                                                .toUpperCase()
                                            : (token['token']['tokenName'] ?? 'Unknown').toUpperCase(),
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4), // Space between name and market cap
                                      Text(
                                        token['mcap']?.toString() ?? '0',
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 50,
                                child: Text(token['volume']?.toString() ?? '0'),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 60,
                                child: Text('${token['24h'] ?? '0'}'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
