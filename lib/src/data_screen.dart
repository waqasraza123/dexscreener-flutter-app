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
        title: const Text('Dex Data'),
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

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Token Name')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Volume')),
                DataColumn(label: Text('Txns')),
                DataColumn(label: Text('Liquidity')),
                DataColumn(label: Text('Market Cap')),
                DataColumn(label: Text('5m Change')),
                DataColumn(label: Text('1h Change')),
                DataColumn(label: Text('6h Change')),
                DataColumn(label: Text('24h Change')),
              ],
              rows: snapshot.data!.map((token) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Image.network(
                            token['token']['tokenImageUrl'],
                            height: 30,
                            width: 30,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(token['token']['tokenName'] ?? 'Unknown'),
                        ],
                      ),
                    ),
                    DataCell(Text(token['price'].toString())),
                    DataCell(Text(token['volume'].toString())),
                    DataCell(Text(token['txns'].toString())),
                    DataCell(Text(token['liquidity'].toString())),
                    DataCell(Text(token['mcap'].toString())),
                    DataCell(Text('${token['5m']}%')),
                    DataCell(Text('${token['1h']}%')),
                    DataCell(Text('${token['6h']}%')),
                    DataCell(Text('${token['24h']}%')),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
