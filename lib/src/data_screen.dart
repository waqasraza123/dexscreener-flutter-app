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
                DataColumn(label: Text('Volume')),
                DataColumn(label: Text('24h Increase')),
                DataColumn(label: Text('Market Cap')),
              ],
              rows: snapshot.data!.map((token) {
                return DataRow(
                  cells: [
                    DataCell(Text(token['token']['tokenName'] ?? 'Unknown')),
                    DataCell(Text(token['volume']?.toString() ?? '0')),
                    DataCell(Text('${token['24h'] ?? '0'}')),
                    DataCell(Text(token['mcap']?.toString() ?? '0')),
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
