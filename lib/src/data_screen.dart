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
  List<dynamic> tokens = [];
  int itemsToLoad = 10; // Number of tokens to load per request
  int currentOffset = 0; // Tracks the current offset for pagination
  int totalTokens = 0; // Total number of tokens available
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialTokens();
  }

  Future<void> _loadInitialTokens() async {
    try {
      final response =
          await apiService.fetchDexData(itemsToLoad, currentOffset);
      setState(() {
        tokens = response['tokensData'];
        totalTokens = response['total'];
        currentOffset += itemsToLoad;
      });
    } catch (e) {
      print('Error loading tokens: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tokens.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoadingMore &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  _loadMoreTokens();
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
            ),
    );
  }

  // Load more tokens when the user scrolls to the bottom
  void _loadMoreTokens() async {
    if (currentOffset >= totalTokens) return; // Stop if all tokens are loaded

    setState(() {
      isLoadingMore = true;
    });

    try {
      final response =
          await apiService.fetchDexData(itemsToLoad, currentOffset);
      setState(() {
        tokens.addAll(response['tokensData']);
        currentOffset += itemsToLoad;
      });
    } catch (e) {
      print('Error loading more tokens: $e');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }
}
