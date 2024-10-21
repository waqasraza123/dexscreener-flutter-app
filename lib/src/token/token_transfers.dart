import 'package:flutter/material.dart';
import '../../services/token_service.dart';

class TokenTransfers extends StatefulWidget {
  final String contractAddress;

  const TokenTransfers({super.key, required this.contractAddress});

  @override
  TokenTransfersState createState() => TokenTransfersState();
}

class TokenTransfersState extends State<TokenTransfers> {
  List<dynamic> displayedTransfers = [];
  int itemsToLoad = 10;
  bool isLoadingMore = false;
  int currentOffset = 0; // To track the current offset

  @override
  void initState() {
    super.initState();
    _loadInitialTransfers(); // Load initial transfers
  }

  // Load initial transfers from the API
  Future<void> _loadInitialTransfers() async {
    final tokenService = TokenService();
    List<dynamic> transfers = await tokenService.fetchTokenTransfers(
        widget.contractAddress, itemsToLoad, currentOffset);

    setState(() {
      displayedTransfers = transfers;
      currentOffset += itemsToLoad; // Update the offset for next loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreTransfers(); // Load more transfers when scrolled to the bottom
        }
        return false;
      },
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Transfers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          displayedTransfers.isNotEmpty
              ? Column(
                  children: displayedTransfers.map<Widget>((transfer) {
                    return ListTile(
                      title: Text(
                          'From: ${transfer['from']} To: ${transfer['to']}'),
                      subtitle: Text(
                          'Amount: ${transfer['amount']} Date: ${transfer['date']}'),
                    );
                  }).toList(),
                )
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent transfers available.'),
                ),
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // Load more transfers when the user scrolls to the bottom
  void _loadMoreTransfers() async {
    setState(() {
      isLoadingMore = true;
    });

    // Simulate a loading delay
    Future.delayed(const Duration(seconds: 2), () async {
      final tokenService = TokenService();
      List<dynamic> transfers = await tokenService.fetchTokenTransfers(
          widget.contractAddress, itemsToLoad, currentOffset);

      setState(() {
        displayedTransfers.addAll(transfers);
        currentOffset += itemsToLoad; // Update the offset for next loading
        isLoadingMore = false;
      });
    });
  }
}
