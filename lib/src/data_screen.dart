import 'package:flutter/material.dart';
import '../services/dex_api_service.dart';
import './token/token_card.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  DataScreenState createState() => DataScreenState();
}

class DataScreenState extends State<DataScreen> {
  final DexApiService apiService = DexApiService();
  late Future<List<dynamic>> dexData;
  List<dynamic> tokens = [];
  int itemsToLoad = 10; // Initial number of tokens to load
  int currentItemCount = 0; // Keeps track of how many tokens are loaded
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    dexData = apiService.fetchDexData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // Load initial set of tokens
          if (tokens.isEmpty) {
            tokens = snapshot.data!.take(itemsToLoad).toList();
            currentItemCount = tokens.length;
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoadingMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadMoreTokens(snapshot.data!);
              }
              return false;
            },
            child: ListView.builder(
              itemCount: tokens.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == tokens.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                var token = tokens[index];
                return TokenCard(token: token);
              },
            ),
          );
        },
      ),
    );
  }

  // Load more tokens when the user scrolls to the bottom
  void _loadMoreTokens(List<dynamic> allTokens) async {
    if (currentItemCount >= allTokens.length) return;

    setState(() {
      isLoadingMore = true;
    });

    await Future.delayed(
        const Duration(seconds: 2)); // Simulate delay for loading

    setState(() {
      int nextItemCount = currentItemCount + itemsToLoad;
      if (nextItemCount > allTokens.length) {
        nextItemCount = allTokens.length;
      }
      tokens.addAll(allTokens.getRange(currentItemCount, nextItemCount));
      currentItemCount = tokens.length;
      isLoadingMore = false;
    });
  }
}
